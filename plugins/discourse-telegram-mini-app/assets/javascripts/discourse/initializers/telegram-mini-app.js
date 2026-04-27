import { ajax } from "discourse/lib/ajax";
import getURL from "discourse/lib/get-url";

export default {
  name: "telegram-mini-app",

  initialize(owner) {
    if (!window.Telegram?.WebApp?.initData) {
      return;
    }

    const siteSettings = owner.lookup("service:site-settings");
    if (!siteSettings.enable_telegram_mini_app) {
      return;
    }

    const currentUser = owner.lookup("service:current-user");
    if (currentUser) {
      return;
    }

    ajax(getURL("/telegram-mini-app/auth"), {
      type: "POST",
      data: { init_data: window.Telegram.WebApp.initData },
    })
      .then(() => window.location.reload())
      .catch((error) => {
        // eslint-disable-next-line no-console
        console.warn("[Telegram Mini App] Auth failed:", error);
      });
  },
};
