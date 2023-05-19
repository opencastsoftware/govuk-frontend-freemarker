<#assign caller><#nested/></#assign caller>
<#if (params.type == "success")??>
  <#assign successBanner=true>
</#if><#if (successBanner)??>
  <#assign typeClass="govuk-notification-banner--" + params.type>
</#if>

<#if (params.role)?has_content>
  <#assign role=params.role>
<#elseif (successBanner)??>
  
  <#assign role="alert">
<#else>
  
  <#assign role="region">
</#if><#if (params.titleHtml)?has_content>
  <#assign title=params.titleHtml?no_esc><#elseif (params.titleText)?has_content>
  <#assign title=params.titleText><#elseif (successBanner)??>
  <#assign title="Success"><#else>
  <#assign title="Important"></#if><div class="govuk-notification-banner<#if (typeClass)??> ${typeClass}</#if><#if (params.classes)?has_content> ${params.classes}</#if>" role="${role}"
  aria-labelledby="${params.titleId!"govuk-notification-banner-title"}"
  data-module="govuk-notification-banner"<#if (params.disableAutoFocus)??> data-disable-auto-focus="${params.disableAutoFocus}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <div class="govuk-notification-banner__header">
    <h${params.titleHeadingLevel!2} class="govuk-notification-banner__title" id="${params.titleId!"govuk-notification-banner-title"}" >
      ${title}
    </h${params.titleHeadingLevel!2}>
  </div>
  <div class="govuk-notification-banner__content"><#if (caller)?? || (params.html)?has_content>${((caller)??)?then(caller, params.html?no_esc)}<#elseif (params.text)?has_content>
      <p class="govuk-notification-banner__heading">${params.text}</p></#if></div>
</div>
