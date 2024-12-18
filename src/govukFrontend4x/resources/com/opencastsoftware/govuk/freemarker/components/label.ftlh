<#macro govukLabelMacro params>
  <#if (params.html)?has_content || (params.text)?has_content>
  <#local labelHtml>
  <label class="govuk-label<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list><#if (params.for)?has_content> for="${(params.for)!}"</#if>>
    ${((params.html)?has_content)?then(params.html?no_esc, (params.text)!)}
  </label>
  </#local>
  
  <#if (params.isPageHeading)?? && params.isPageHeading>
  <h1 class="govuk-label-wrapper">${labelHtml?no_esc}</h1>
  <#else>
  ${labelHtml?no_esc}
  </#if>
  </#if>
  
</#macro>

<#function govukLabel params>
  <#local result><@govukLabelMacro params=params/></#local>
  <#return result>
</#function>