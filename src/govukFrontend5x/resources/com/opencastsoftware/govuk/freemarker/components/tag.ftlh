<#macro govukTagMacro params>
  <#import "../macros/attributes.ftlh" as attributes><strong class="govuk-tag<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}
  </strong>
  
</#macro>

<#function govukTag params>
  <#local result><@govukTagMacro params=params/></#local>
  <#return result>
</#function>