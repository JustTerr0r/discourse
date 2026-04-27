# frozen_string_literal: true

module ::TelegramMiniApp
  PLUGIN_NAME = "discourse-telegram-mini-app"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace TelegramMiniApp
    config.autoload_paths << File.join(config.root, "lib")
  end
end
