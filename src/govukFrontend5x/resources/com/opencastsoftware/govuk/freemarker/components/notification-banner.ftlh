<#macro govukNotificationBannerMacro params>
  <#local caller><#nested/></#local>
  <#import "../macros/attributes.ftlh" as attributes><#if (params.type)! == "success">
    <#local successBanner=true>
  </#if><#if (successBanner)?? && successBanner>
    <#local typeClass="govuk-notification-banner--" + params.type>
  </#if><#if (params.role)?has_content>
    <#local role=(params.role)!>
  <#elseif (successBanner)?? && successBanner><#local role="alert">
  <#else><#local role="region">
  </#if><#if (params.titleHtml)?has_content>
    <#local title=params.titleHtml?no_esc><#elseif (params.titleText)?has_content>
    <#local title=(params.titleText)!><#elseif (successBanner)?? && successBanner>
    <#local title="Success"><#else>
    <#local title="Important"></#if><div class="govuk-notification-banner<#if (typeClass)?has_content> ${(typeClass)!}</#if><#if (params.classes)?has_content> ${(params.classes)!}</#if>" role="${(role)!}" aria-labelledby="${((params.titleId)?has_content)?then(params.titleId, "govuk-notification-banner-title")}" data-module="govuk-notification-banner"<#if (params.disableAutoFocus)??> data-disable-auto-focus="${((params.disableAutoFocus)!false)}"</#if>${attributes.govukAttributes(((params.attributes)!{}))}>
    <div class="govuk-notification-banner__header">
      <h${((params.titleHeadingLevel)?has_content)?then(params.titleHeadingLevel, 2)} class="govuk-notification-banner__title" id="${((params.titleId)?has_content)?then(params.titleId, "govuk-notification-banner-title")}">
        ${(title)!}
      </h${((params.titleHeadingLevel)?has_content)?then(params.titleHeadingLevel, 2)}>
    </div>
    <div class="govuk-notification-banner__content">
    <#if (caller)?has_content || (params.html)?has_content>
      ${((caller)?has_content)?then(caller, params.html?no_esc?markup_string?trim?no_esc)}
    <#elseif (params.text)?has_content>
      <p class="govuk-notification-banner__heading">
        ${params.text?trim}
      </p>
    </#if>
    </div>
  </div>
  
</#macro>

<#function govukNotificationBanner params>
  <#local result><@govukNotificationBannerMacro params=params/></#local>
  <#return result>
</#function>