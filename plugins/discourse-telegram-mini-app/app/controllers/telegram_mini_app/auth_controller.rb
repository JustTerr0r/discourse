# frozen_string_literal: true

module TelegramMiniApp
  class AuthController < ::ApplicationController
    requires_plugin TelegramMiniApp::PLUGIN_NAME

    # The HMAC-SHA256 signature in initData is stronger proof of request origin
    # than a synchronised CSRF token — same justification used in
    # OmniauthCallbacksController.
    skip_before_action :verify_authenticity_token, only: :auth
    skip_before_action :redirect_to_login_if_required, :redirect_to_profile_if_required, only: :auth

    allow_in_staff_writes_only_mode :auth

    PROVIDER_NAME = "telegram"
    AUTH_MAX_AGE = 1.hour.to_i
    NOREPLY_DOMAIN = "users.noreply.discourse.org"

    def auth
      unless SiteSetting.enable_telegram_mini_app?
        return render_json_error(I18n.t("login.not_allowed"), status: 403)
      end

      if SiteSetting.telegram_bot_token.blank?
        return render_json_error("Telegram bot token not configured.", status: 503)
      end

      init_data_raw = params.require(:init_data)

      tg_user, error = verify_and_parse_init_data(init_data_raw)
      return render_json_error(error, status: 401) if error

      RateLimiter.new(
        nil,
        "tg-auth-ip-#{request.remote_ip}",
        SiteSetting.max_logins_per_ip_per_hour,
        1.hour,
      ).performed!

      if ScreenedIpAddress.should_block?(request.remote_ip)
        return render_json_error(I18n.t("login.not_allowed_from_ip_address"), status: 403)
      end

      user = find_or_create_telegram_user(tg_user)

      return render_json_error(user.suspended_message, status: 403) if user.suspended?

      unless Guardian.new(user).can_access_forum? && user.active?
        return render_json_error(I18n.t("login.not_approved"), status: 403)
      end

      log_on_user(user, authenticated_with_oauth: true)

      render json:
               success_json.merge(
                 username: user.username,
                 destination_url: Discourse.base_path("/"),
               )
    rescue RateLimiter::LimitExceeded
      render_json_error(I18n.t("rate_limiter.slow_down"), status: 429)
    end

    private

    def verify_and_parse_init_data(init_data_raw)
      pairs = URI.decode_www_form(init_data_raw).to_h
      received_hash = pairs.delete("hash")

      return nil, "Missing hash in initData" if received_hash.blank?

      auth_date = pairs["auth_date"].to_i
      age = Time.zone.now.to_i - auth_date
      return nil, "initData expired" if age < 0 || age > AUTH_MAX_AGE

      data_check_string = pairs.sort.map { |k, v| "#{k}=#{v}" }.join("\n")

      secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", SiteSetting.telegram_bot_token)
      expected_hex = OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)

      unless ActiveSupport::SecurityUtils.secure_compare(expected_hex, received_hash)
        return nil, "initData signature verification failed"
      end

      user_json = pairs["user"]
      return nil, "Missing user in initData" if user_json.blank?

      [JSON.parse(user_json), nil]
    rescue JSON::ParserError
      [nil, "Malformed user JSON in initData"]
    end

    def find_or_create_telegram_user(tg_user)
      tg_id = tg_user["id"].to_s

      association =
        UserAssociatedAccount.find_or_initialize_by(
          provider_name: PROVIDER_NAME,
          provider_uid: tg_id,
        )

      if association.user
        update_association(association, tg_user)
        return association.user
      end

      DistributedMutex.synchronize("telegram_auth_#{tg_id}") do
        association =
          UserAssociatedAccount.find_or_initialize_by(
            provider_name: PROVIDER_NAME,
            provider_uid: tg_id,
          )
        return association.user if association.user

        user = build_telegram_user(tg_id, tg_user)
        user.save!
        user.activate

        association.user = user
        update_association(association, tg_user)

        if tg_user["photo_url"].present?
          Jobs.enqueue(:download_avatar_from_url, url: tg_user["photo_url"], user_id: user.id)
        end

        user.enqueue_welcome_message("welcome_user")
        user
      end
    end

    def build_telegram_user(tg_id, tg_user)
      name = [tg_user["first_name"], tg_user["last_name"]].map(&:presence)
        .compact
        .join(" ")
        .presence

      user =
        User.new(
          email: "tg_#{tg_id}@#{NOREPLY_DOMAIN}",
          username: UserNameSuggester.suggest(tg_user["username"], tg_user["first_name"]),
          name: name,
          active: true,
          registration_ip_address: request.remote_ip,
          ip_address: request.remote_ip,
          locale: tg_user["language_code"].presence,
        )
      user.skip_email_validation = true
      user.password = SecureRandom.hex
      user
    end

    def update_association(association, tg_user)
      association.info =
        tg_user.slice("id", "first_name", "last_name", "username", "photo_url", "language_code")
      association.credentials = {}
      association.extra = {}
      association.last_used = Time.zone.now
      association.save!
    end
  end
end
