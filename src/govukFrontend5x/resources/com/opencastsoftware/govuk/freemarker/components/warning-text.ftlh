<#macro govukWarningTextMacro params>
  <#import "../macros/attributes.ftlh" as attributes><div class="govuk-warning-text<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)}>
    <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
    <strong class="govuk-warning-text__text">
      <span class="govuk-visually-hidden">${((params.iconFallbackText)?has_content)?then(params.iconFallbackText, "Warning")}</span>
      ${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}
    </strong>
  </div>
  
</#macro>

<#function govukWarningText params>
  <#local result><@govukWarningTextMacro params=params/></#local>
  <#return result>
</#function>