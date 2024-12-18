<#macro govukInsetTextMacro params>
  <#local caller><#nested/></#local>
  <div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-inset-text<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
    ${((caller)?has_content)?then(caller, (((params.html)?has_content)?then(params.html?no_esc, (params.text)!)))}
  </div>
  
</#macro>

<#function govukInsetText params>
  <#local result><@govukInsetTextMacro params=params/></#local>
  <#return result>
</#function>