<#macro govukNotificationBannerMacro params>
  <#local caller><#nested/></#local>
  <#if (params.type == "success")??>
    <#local successBanner=true>
  </#if><#if (successBanner)??>
    <#local typeClass="govuk-notification-banner--" + params.type>
  </#if>
  
  <#if (params.role)?has_content>
    <#local role=params.role>
  <#elseif (successBanner)??>
    
    <#local role="alert">
  <#else>
    
    <#local role="region">
  </#if><#if (params.titleHtml)?has_content>
    <#local title=params.titleHtml?no_esc><#elseif (params.titleText)?has_content>
    <#local title=params.titleText><#elseif (successBanner)??>
    <#local title="Success"><#else>
    <#local title="Important"></#if><div class="govuk-notification-banner<#if (typeClass)??> ${typeClass}</#if><#if (params.classes)?has_content> ${params.classes}</#if>" role="${role}"
    aria-labelledby="${params.titleId!("govuk-notification-banner-title")}"
    data-module="govuk-notification-banner"<#if (params.disableAutoFocus)??> data-disable-auto-focus="${params.disableAutoFocus}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <div class="govuk-notification-banner__header">
      <h${params.titleHeadingLevel!(2)} class="govuk-notification-banner__title" id="${params.titleId!("govuk-notification-banner-title")}" >
        ${title}
      </h${params.titleHeadingLevel!(2)}>
    </div>
    <div class="govuk-notification-banner__content"><#if (caller)?has_content || (params.html)?has_content>${((caller)?has_content)?then(caller, params.html?no_esc)}<#elseif (params.text)?has_content>
        <p class="govuk-notification-banner__heading">${params.text}</p></#if></div>
  </div>
  
</#macro>

<#function govukNotificationBanner params>
  <#local result><@govukNotificationBannerMacro params=params/></#local>
  <#return result>
</#function>