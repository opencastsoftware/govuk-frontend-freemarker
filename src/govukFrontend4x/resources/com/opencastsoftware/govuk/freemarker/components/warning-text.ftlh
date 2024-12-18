<#macro govukWarningTextMacro params>
  <div class="govuk-warning-text${((params.classes)?has_content)?then(" " + params.classes, "")}"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
    <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
    <strong class="govuk-warning-text__text">
      <span class="govuk-warning-text__assistive">${params.iconFallbackText!("Warning")}</span>
      ${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}
    </strong>
  </div>
  
</#macro>

<#function govukWarningText params>
  <#local result><@govukWarningTextMacro params=params/></#local>
  <#return result>
</#function>