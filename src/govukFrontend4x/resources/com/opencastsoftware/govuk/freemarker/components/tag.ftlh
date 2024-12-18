<#macro govukTagMacro params>
  <strong class="govuk-tag<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
    ${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}
  </strong>
  
</#macro>

<#function govukTag params>
  <#local result><@govukTagMacro params=params/></#local>
  <#return result>
</#function>