<#macro govukCookieBannerMacro params>
  <#import "./button.ftlh" as button><div class="govuk-cookie-banner ${((params.classes)?has_content)?then(params.classes, "")}" data-nosnippet role="region" aria-label="${params.ariaLabel!"Cookie banner"}"<#if (params.hidden)?? && params.hidden> hidden</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>><#list params.messages as message>
      <#local classNames="govuk-cookie-banner__message govuk-width-container">
      <#if (message.classes)?has_content>
        <#local classNames=classNames + " " + message.classes>
      </#if>
  
      <div class="${classNames}"<#if (message.role)?has_content> role="${message.role}"</#if><#list message.attributes!{} as attribute, value> ${attribute}="${value}"</#list><#if (message.hidden)?? && message.hidden> hidden</#if>>
  
      <div class="govuk-grid-row">
        <div class="govuk-grid-column-two-thirds">
          <#if (message.headingHtml)?has_content || (message.headingText)?has_content>
          <h2 class="govuk-cookie-banner__heading govuk-heading-m"><#if (message.headingHtml)?has_content>${message.headingHtml?no_esc}<#else>${message.headingText}</#if></h2>
          </#if>
  
          <div class="govuk-cookie-banner__content"><#if (message.html)?has_content>${message.html?no_esc}<#elseif (message.text)?has_content><p class="govuk-body">${message.text}</p></#if></div>
        </div>
      </div>
  
        <#if (message.actions)??>
        <div class="govuk-button-group">
          <#list message.actions![] as action>
            <#if (action.href)??>
              <#if (action.type == "button")??>
                ${button.govukButton({ "text": action.text, "type": "button", "classes": action.classes, "href": action.href, "attributes": action.attributes })?trim}
              <#else>
                <#local linkClasses="govuk-link">
                <#if (action.classes)??>
                  <#local linkClasses=linkClasses + " " + action.classes>
                </#if>
                <a class="${linkClasses}" href="${action.href}"<#list action.attributes![] as attribute, value> ${attribute}="${value}"</#list>>${action.text}</a>
              </#if>
            <#else>
              ${button.govukButton({ "text": action.text, "value": action.value, "name": action.name, "type": action.type, "classes": action.classes, "attributes": action.attributes })?trim}
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