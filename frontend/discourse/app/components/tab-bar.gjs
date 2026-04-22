import Component from "@glimmer/component";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import htmlClass from "discourse/helpers/html-class";
import { i18n } from "discourse-i18n";

export default class TabBar extends Component {
  @service router;

  get isSecondTabActive() {
    return this.router.currentRouteName?.startsWith("second-tab");
  }

  <template>
    {{htmlClass "tab-bar-visible"}}
    <nav class="tab-bar" aria-label={{i18n "tab_bar.aria_label"}}>
      <LinkTo
        @route="discovery.latest"
        @activeClass=""
        class={{concatClass
          "tab-bar__tab"
          (unless this.isSecondTabActive "tab-bar__tab--active")
        }}
        aria-current={{unless this.isSecondTabActive "page"}}
      >
        {{icon "comments"}}
        <span class="tab-bar__tab-label">{{i18n "tab_bar.forum"}}</span>
      </LinkTo>
      <LinkTo
        @route="second-tab"
        @activeClass=""
        class={{concatClass
          "tab-bar__tab"
          (if this.isSecondTabActive "tab-bar__tab--active")
        }}
        aria-current={{if this.isSecondTabActive "page"}}
      >
        {{icon "layer-group"}}
        <span class="tab-bar__tab-label">{{i18n "tab_bar.placeholder"}}</span>
      </LinkTo>
    </nav>
  </template>
}
