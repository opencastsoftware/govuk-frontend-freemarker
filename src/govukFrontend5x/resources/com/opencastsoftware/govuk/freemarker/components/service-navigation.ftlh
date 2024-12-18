<#macro govukServiceNavigationMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local menuButtonText=((params.menuButtonText)?has_content)?then(params.menuButtonText, "Menu")><#local navigationId=((params.navigationId)?has_content)?then(params.navigationId, "navigation")><#local commonAttributes>
  class="govuk-service-navigation<#if (params.classes)?has_content> ${(params.classes)!}</#if>"
  data-module="govuk-service-navigation"${attributes.govukAttributes(params.attributes)}
  </#local><#local innerContent>
    <div class="govuk-width-container">
  
      <#if (params.slots.start)?has_content>${params.slots.start?no_esc}</#if><div class="govuk-service-navigation__container">
        
        <#if (params.serviceName)?has_content>
          <span class="govuk-service-navigation__service-name">
            <#if (params.serviceUrl)?has_content>
              <a href="${(params.serviceUrl)!}" class="govuk-service-navigation__link">
                ${(params.serviceName)!}
              </a>
            <#else>
              <span class="govuk-service-navigation__text">${(params.serviceName)!}</span>
            </#if>
          </span>
        </#if>
  
        
        <#if (params.navigation?size != 0) && (!params.navigation?size?is_nan) || (params.slots.navigationStart)?has_content || (params.slots.navigationEnd)?has_content>
          <nav aria-label="${((params.navigationLabel)?has_content)?then(params.navigationLabel, menuButtonText)}" class="govuk-service-navigation__wrapper<#if (params.navigationClasses)?has_content> ${(params.navigationClasses)!}</#if>">
            <button type="button" class="govuk-service-navigation__toggle govuk-js-service-navigation-toggle" aria-controls="${(navigationId)!}"<#if (params.menuButtonLabel)?has_content && (params.menuButtonLabel)! != (menuButtonText)!> aria-label="${(params.menuButtonLabel)!}"</#if> hidden>
              ${(menuButtonText)!}
            </button>
  
            <ul class="govuk-service-navigation__list" id="${(navigationId)!}" >
  
              <#if (params.slots.navigationStart)?has_content>${params.slots.navigationStart?no_esc}</#if><#list params.navigation as item>
                <#local linkInnerContent>
                  
                  <#if (item.active)?? && item.active || (item.current)?? && item.current>
                    <strong class="govuk-service-navigation__active-fallback">${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}</strong>
                  <#else>${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}</#if>
                </#local>
  
                
                <li class="govuk-service-navigation__item<#if (item.active)?? && item.active || (item.current)?? && item.current> govuk-service-navigation__item--active</#if>">
                  <#if (item.href)?has_content>
                    <a class="govuk-service-navigation__link" href="${(item.href)!}"<#if (item.active)?? && item.active || (item.current)?? && item.current> aria-current="${((item.current)?? && item.current)?then("page", "true")}"</#if>${attributes.govukAttributes(item.attributes)}>
                      ${linkInnerContent?no_esc}
                    </a>
                  <#elseif (item.html)?has_content || (item.text)?has_content>
                    <span class="govuk-service-navigation__text"<#if (item.active)?? && item.active || (item.current)?? && item.current> aria-current="${((item.current)?? && item.current)?then("page", "true")}"</#if>>
                      ${linkInnerContent?no_esc}
                    </span>
                  </#if>
                </li>
              </#list>
  
              <#if (params.slots.navigationEnd)?has_content>${params.slots.navigationEnd?no_esc}</#if></ul>
          </nav>
        </#if>
      </div>
  
      <#if (params.slots.end)?has_content>${params.slots.end?no_esc}</#if></div>
  </#local>
  <#if (params.serviceName)?has_content || (params.slots.start)?has_content || (params.slots.end)?has_content>
    <section aria-label="${params.ariaLabel!("Service information")}" ${commonAttributes?no_esc}>
      ${innerContent?no_esc}
    </section>
  <#else>
    <div ${commonAttributes?no_esc}>
      ${innerContent?no_esc}
    </div>
  </#if>
  
</#macro>

<#function govukServiceNavigation params>
  <#local result><@govukServiceNavigationMacro params=params/></#local>
  <#return result>
</#function>