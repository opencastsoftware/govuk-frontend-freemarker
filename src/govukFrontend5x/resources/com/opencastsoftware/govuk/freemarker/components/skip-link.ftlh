<#macro govukSkipLinkMacro params>
  <#import "../macros/attributes.ftlh" as attributes><a href="${((params.href)?has_content)?then(params.href, "#content")}" class="govuk-skip-link<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)} data-module="govuk-skip-link">${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}</a>
  
</#macro>

<#function govukSkipLink params>
  <#local result><@govukSkipLinkMacro params=params/></#local>
  <#return result>
</#function>