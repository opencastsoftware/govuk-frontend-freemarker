<#macro govukBackLinkMacro params>
  <a href="<#if (params.href)?has_content>${params.href}<#else>#</#if>" class="govuk-back-link<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>${(((params.html)?has_content)?then(params.html?no_esc, (((params.text)?has_content)?then((params.text)!, "Back"))))}</a>
  
</#macro>

<#function govukBackLink params>
  <#local result><@govukBackLinkMacro params=params/></#local>
  <#return result>
</#function>