<#macro govukCookieBannerMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./button.ftlh" as button><div class="govuk-cookie-banner<#if (params.classes)?has_content> ${(params.classes)!}</#if>" data-nosnippet role="region" aria-label="${((params.ariaLabel)?has_content)?then(params.ariaLabel, "Cookie banner")}"<#if (params.hidden)?? && params.hidden> hidden</#if>${attributes.govukAttributes(params.attributes)}>
    <#list params.messages as message>
    <div class="govuk-cookie-banner__message<#if (message.classes)?has_content> ${(message.classes)!}</#if> govuk-width-container"<#if (message.role)?has_content> role="${(message.role)!}"</#if>${attributes.govukAttributes(message.attributes)}<#if (message.hidden)?? && message.hidden> hidden</#if>>
  
      <div class="govuk-grid-row">
        <div class="govuk-grid-column-two-thirds">
          <#if (message.headingHtml)?has_content || (message.headingText)?has_content>
          <h2 class="govuk-cookie-banner__heading govuk-heading-m">
            ${((message.headingHtml)?has_content)?then(message.headingHtml?no_esc?markup_string?trim?no_esc, (message.headingText)!)}
          </h2>
          </#if>
          <div class="govuk-cookie-banner__content">
            <#if (message.html)?has_content>
            ${message.html?no_esc?markup_string?trim?no_esc}
            <#elseif (message.text)?has_content>
            <p class="govuk-body">${(message.text)!}</p>
            </#if>
          </div>
        </div>
      </div>
  
      <#if (message.actions)??>
      <div class="govuk-button-group">
      <#list message.actions![] as action>
        <#local buttonHtml>
          <#if !((action.href)?has_content) || (action.type)! == "button">
            ${button.govukButton({ "type": ((action.type)?has_content)?then(action.type, "button") } + ((action.text)??)?then({ "text": action.text }, {}) + ((action.name)??)?then({ "name": action.name }, {}) + ((action.value)??)?then({ "value": action.value }, {}) + ((action.classes)??)?then({ "classes": action.classes }, {}) + ((action.href)??)?then({ "href": action.href }, {}) + ((action.attributes)??)?then({ "attributes": action.attributes }, {}))}
          <#else>
            <a class="govuk-link<#if (action.classes)?has_content> ${(action.classes)!}</#if>" href="${(action.href)!}"${attributes.govukAttributes(action.attributes)}>${(action.text)!}</a>
          </#if></#local>
        ${buttonHtml?markup_string?trim?no_esc}
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