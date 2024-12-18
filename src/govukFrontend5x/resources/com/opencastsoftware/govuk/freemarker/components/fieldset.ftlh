<#macro govukFieldsetMacro params>
  <#local caller><#nested/></#local>
  <#import "../macros/attributes.ftlh" as attributes><fieldset class="govuk-fieldset<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#if (params.role)?has_content> role="${(params.role)!}"</#if><#if (params.describedBy)?has_content> aria-describedby="${(params.describedBy)!}"</#if>${attributes.govukAttributes(params.attributes)}>
    <#if (params.legend.html)?has_content || (params.legend.text)?has_content>
    <legend class="govuk-fieldset__legend<#if (params.legend.classes)?has_content> ${(params.legend.classes)!}</#if>">
    <#if (params.legend.isPageHeading)?? && params.legend.isPageHeading>
      <h1 class="govuk-fieldset__heading">
        ${((params.legend.html)?has_content)?then(params.legend.html?no_esc?markup_string?trim?no_esc, (params.legend.text)!)}
      </h1>
    <#else>
      ${((params.legend.html)?has_content)?then(params.legend.html?no_esc?markup_string?trim?no_esc, (params.legend.text)!)}
    </#if>
    </legend>
    </#if>
  <#if (caller)?has_content>${caller}
  <#elseif (params.html)?has_content>
    ${params.html?no_esc}
  </#if>
  </fieldset>
  
</#macro>

<#function govukFieldset params>
  <#local result><@govukFieldsetMacro params=params/></#local>
  <#return result>
</#function>