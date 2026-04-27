# frozen_string_literal: true

TelegramMiniApp::Engine.routes.draw { post "/auth" => "auth#auth" }

Discourse::Application.routes.draw { mount TelegramMiniApp::Engine, at: "telegram-mini-app" }
