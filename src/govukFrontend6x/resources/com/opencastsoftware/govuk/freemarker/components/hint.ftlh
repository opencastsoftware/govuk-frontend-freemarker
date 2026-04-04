<#macro govukHintMacro params>
  <#import "../macros/attributes.ftlh" as attributes><div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-hint<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}
  </div>
  
</#macro>

<#function govukHint params>
  <#local result><@govukHintMacro params=params/></#local>
  <#return result>
</#function>