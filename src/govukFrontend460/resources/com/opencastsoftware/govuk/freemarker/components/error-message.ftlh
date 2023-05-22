<#macro govukErrorMessageMacro params>
  <#local visuallyHiddenText=params.visuallyHiddenText!"Error"><p<#if (params.id)?has_content> id="${params.id}"</#if> class="govuk-error-message<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <#if (visuallyHiddenText)??><span class="govuk-visually-hidden">${visuallyHiddenText}:</span> </#if>${((params.html)?has_content)?then(params.html?no_esc, params.text)}
  </p>
  
</#macro>

<#function govukErrorMessage params>
  <#local result><@govukErrorMessageMacro params=params/></#local>
  <#return result>
</#function>