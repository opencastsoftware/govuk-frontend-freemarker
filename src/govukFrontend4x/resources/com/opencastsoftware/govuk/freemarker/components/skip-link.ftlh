<#macro govukSkipLinkMacro params>
  <a href="${params.href!("#content")}" class="govuk-skip-link<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list> data-module="govuk-skip-link">${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}</a>
  
</#macro>

<#function govukSkipLink params>
  <#local result><@govukSkipLinkMacro params=params/></#local>
  <#return result>
</#function>