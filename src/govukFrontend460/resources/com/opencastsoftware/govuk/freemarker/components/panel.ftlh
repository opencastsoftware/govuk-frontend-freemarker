<#macro govukPanelMacro params>
  <#local caller><#nested/></#local>
  <#local headingLevel=((params.headingLevel != 0) && (!params.headingLevel?is_nan))?then(params.headingLevel, 1)>
  <div class="govuk-panel govuk-panel--confirmation<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <h${headingLevel} class="govuk-panel__title">
      ${((params.titleHtml)?has_content)?then(params.titleHtml?no_esc, params.titleText)}
    </h${headingLevel}>
    <#if (caller)?has_content || (params.html)?has_content || (params.text)?has_content>
    <div class="govuk-panel__body">
      ${((caller)?has_content)?then(caller, (((params.html)?has_content)?then(params.html?no_esc, params.text)))}
    </div>
    </#if>
  </div>
  
</#macro>

<#function govukPanel params>
  <#local result><@govukPanelMacro params=params/></#local>
  <#return result>
</#function>