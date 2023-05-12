<#assign caller><#nested/></#assign caller>
<#if (params.type == "success")??>
  <#assign successBanner=true>
</#if><#if (successBanner)??>
  <#assign typeClass="govuk-notification-banner--" + params.type>
</#if>

<#if (params.role)??>
  <#assign role=params.role>
<#elseif (successBanner)??>
  
  <#assign role="alert">
<#else>
  
  <#assign role="region">
</#if><#if (params.titleHtml)??>
  <#assign title=params.titleHtml?no_esc><#elseif (params.titleText)??>
  <#assign title=params.titleText><#elseif (successBanner)??>
  <#assign title="Success"><#else>
  <#assign title="Important"></#if><div class="govuk-notification-banner<#if (typeClass)??> ${typeClass}</#if><#if (params.classes)??> ${params.classes}</#if>" role="${role}"
  aria-labelledby="${params.titleId!"govuk-notification-banner-title"}"
  data-module="govuk-notification-banner"<#if (params.disableAutoFocus)?? && params.disableAutoFocus> data-disable-auto-focus="${(params.disableAutoFocus?c)}"</#if><#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <div class="govuk-notification-banner__header">
    <h${params.titleHeadingLevel!2} class="govuk-notification-banner__title" id="${params.titleId!"govuk-notification-banner-title"}" >
      ${title}
    </h${params.titleHeadingLevel!2}>
  </div>
  <div class="govuk-notification-banner__content"><#if (caller)?? || (params.html)??>${((caller)??)?then(caller, params.html?no_esc)}<#elseif (params.text)??>
      <p class="govuk-notification-banner__heading">${params.text}</p></#if></div>
</div>
