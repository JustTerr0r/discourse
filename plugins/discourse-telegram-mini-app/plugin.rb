# frozen_string_literal: true

# name: discourse-telegram-mini-app
# about: Telegram Mini App authentication and custom tab bar for Discourse
# version: 0.1
# authors: Finesse
# url: https://github.com/

enabled_site_setting :enable_telegram_mini_app

register_asset "stylesheets/tab-bar.scss"

require_relative "lib/telegram_mini_app/engine"
