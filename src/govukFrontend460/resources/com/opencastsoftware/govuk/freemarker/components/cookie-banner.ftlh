<#macro govukCookieBannerMacro params>
  <#import "./button.ftlh" as button><div class="govuk-cookie-banner ${((params.classes)?has_content)?then((params.classes)!, "")}" data-nosnippet role="region" aria-label="${params.ariaLabel!("Cookie banner")}"<#if (params.hidden)?? && params.hidden> hidden</#if><#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>><#list params.messages as message>
      <#local classNames="govuk-cookie-banner__message govuk-width-container">
      <#if (message.classes)?has_content>
        <#local classNames=classNames + " " + message.classes>
      </#if>
  
      <div class="${(classNames)!}"<#if (message.role)?has_content> role="${(message.role)!}"</#if><#list message.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list><#if (message.hidden)?? && message.hidden> hidden</#if>>
  
      <div class="govuk-grid-row">
        <div class="govuk-grid-column-two-thirds">
          <#if (message.headingHtml)?has_content || (message.headingText)?has_content>
          <h2 class="govuk-cookie-banner__heading govuk-heading-m"><#if (message.headingHtml)?has_content>${message.headingHtml?no_esc}<#else>${(message.headingText)!}</#if></h2>
          </#if>
  
          <div class="govuk-cookie-banner__content"><#if (message.html)?has_content>${message.html?no_esc}<#elseif (message.text)?has_content><p class="govuk-body">${(message.text)!}</p></#if></div>
        </div>
      </div>
  
        <#if (message.actions)??>
        <div class="govuk-button-group">
          <#list message.actions![] as action>
            <#if (action.href)?has_content>
              <#if (action.type)! == "button">
                ${button.govukButton({ "type": "button" } + ((action.text)??)?then({ "text": action.text }, {}) + ((action.classes)??)?then({ "classes": action.classes }, {}) + ((action.href)??)?then({ "href": action.href }, {}) + ((action.attributes)??)?then({ "attributes": action.attributes }, {}))?markup_string?trim?no_esc}
              <#else>
                <#local linkClasses="govuk-link">
                <#if (action.classes)?has_content>
                  <#local linkClasses=linkClasses + " " + action.classes>
                </#if>
                <a class="${(linkClasses)!}" href="${(action.href)!}"<#list action.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>${(action.text)!}</a>
              </#if>
            <#else>
              ${button.govukButton(((action.text)??)?then({ "text": action.text }, {}) + ((action.value)??)?then({ "value": action.value }, {}) + ((action.name)??)?then({ "name": action.name }, {}) + ((action.type)??)?then({ "type": action.type }, {}) + ((action.classes)??)?then({ "classes": action.classes }, {}) + ((action.attributes)??)?then({ "attributes": action.attributes }, {}))?markup_string?trim?no_esc}
            </#if>
          </#list>
        </div>
        </#if>
      </div>
    </#list>
  </div>
  
</#macro>

<#function govukCookieBanner params>
  <#local result><@govukCookieBannerMacro params=params/></#local>
  <#return result>
</#function>