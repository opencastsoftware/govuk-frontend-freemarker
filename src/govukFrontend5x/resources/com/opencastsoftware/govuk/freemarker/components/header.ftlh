<#macro govukHeaderMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#import "../macros/logo.ftlh" as logo><#local _rebrand=(params.rebrand)!(((govukRebrand)?is_method)?then(govukRebrand(), govukRebrand))><#local menuButtonText=((params.menuButtonText)?has_content)?then((params.menuButtonText)!, "Menu")><header class="govuk-header<#if (params.classes)?has_content> ${(params.classes)!}</#if>" data-module="govuk-header"${attributes.govukAttributes(((params.attributes)!{}))}>
    <div class="govuk-header__container ${((params.containerClasses)?has_content)?then(params.containerClasses, "govuk-width-container")}">
      <div class="govuk-header__logo">
        <a href="${((params.homepageUrl)?has_content)?then(params.homepageUrl, "/")}" class="govuk-header__link govuk-header__link--homepage">
          ${logo.govukLogo({ "classes": "govuk-header__logotype", "ariaLabelText": "GOV.UK" } + ((params.useTudorCrown)??)?then({ "useTudorCrown": params.useTudorCrown }, {}) + ((_rebrand)??)?then({ "rebrand": _rebrand }, {}))?markup_string?trim?no_esc}
          <#if ((params.productName)?has_content)>
          <span class="govuk-header__product-name">${(params.productName)!}</span>
          </#if>
        </a>
      </div>
    <#if (params.serviceName)?has_content || (params.navigation?size != 0) && (!params.navigation?size?is_nan)>
      <div class="govuk-header__content">
      <#if (params.serviceName)?has_content>
        <#if (params.serviceUrl)?has_content>
        <a href="${(params.serviceUrl)!}" class="govuk-header__link govuk-header__service-name">
          ${(params.serviceName)!}
        </a>
        <#else>
        <span class="govuk-header__service-name">
          ${(params.serviceName)!}
        </span>
        </#if>
      </#if>
      <#if (params.navigation?size != 0) && (!params.navigation?size?is_nan)>
        <nav aria-label="${((params.navigationLabel)?has_content)?then(params.navigationLabel, menuButtonText)}" class="govuk-header__navigation<#if (params.navigationClasses)?has_content> ${(params.navigationClasses)!}</#if>">
          <button type="button" class="govuk-header__menu-button govuk-js-header-toggle" aria-controls="navigation"<#if (params.menuButtonLabel)?has_content && (params.menuButtonLabel)! != (menuButtonText)!> aria-label="${(params.menuButtonLabel)!}"</#if> hidden>
            ${(menuButtonText)!}
          </button>
  
          <ul id="navigation" class="govuk-header__navigation-list">
          <#list params.navigation![] as item>
            <#if (item.text)?has_content || (item.html)?has_content>
            <li class="govuk-header__navigation-item<#if (item.active)?? && item.active> govuk-header__navigation-item--active</#if>">
              <#if (item.href)?has_content>
              <a class="govuk-header__link" href="${(item.href)!}"${attributes.govukAttributes(((item.attributes)!{}))}>
              </#if>
                ${((item.html)?has_content)?then(item.html?no_esc?markup_string?trim?no_esc, (item.text)!)}
              <#if (item.href)?has_content>
              </a>
              </#if>
            </li>
            </#if>
          </#list>
          </ul>
        </nav>
      </#if>
      </div>
    </#if>
    </div>
  </header>
  
</#macro>

<#function govukHeader params>
  <#local result><@govukHeaderMacro params=params/></#local>
  <#return result>
</#function>