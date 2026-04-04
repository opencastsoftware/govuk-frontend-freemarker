<#macro govukErrorMessageMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local visuallyHiddenText=(params.visuallyHiddenText)!("Error")><#local errorMessageText=((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)><p<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-error-message<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    <#if (visuallyHiddenText)?has_content>
    <span class="govuk-visually-hidden">${(visuallyHiddenText)!}:</span> ${(errorMessageText)!}
    <#else>
    ${(errorMessageText)!}
    </#if>
  </p>
  
</#macro>

<#function govukErrorMessage params>
  <#local result><@govukErrorMessageMacro params=params/></#local>
  <#return result>
</#function>