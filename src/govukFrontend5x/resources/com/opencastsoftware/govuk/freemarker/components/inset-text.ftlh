<#macro govukInsetTextMacro params>
  <#local caller><#nested/></#local>
  <#import "../macros/attributes.ftlh" as attributes><div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-inset-text<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    ${((caller)?has_content)?then(caller, (((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)))}
  </div>
  
</#macro>

<#function govukInsetText params>
  <#local result><@govukInsetTextMacro params=params/></#local>
  <#return result>
</#function>