<#macro govukBackLinkMacro params>
  <#import "../macros/attributes.ftlh" as attributes><a href="${((params.href)?has_content)?then(params.href, "#")}" class="govuk-back-link<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)}>${((params.html)?has_content)?then(params.html?no_esc, (((params.text)?has_content)?then(params.text, "Back")))}</a>
  
</#macro>

<#function govukBackLink params>
  <#local result><@govukBackLinkMacro params=params/></#local>
  <#return result>
</#function>