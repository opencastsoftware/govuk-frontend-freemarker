<#macro govukHintMacro params>
  <div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-hint<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
    ${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}
  </div>
  
</#macro>

<#function govukHint params>
  <#local result><@govukHintMacro params=params/></#local>
  <#return result>
</#function>