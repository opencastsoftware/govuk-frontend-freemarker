<#macro govukLabelMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#if (params.html)?has_content || (params.text)?has_content>
  <#local labelHtml>
  <label class="govuk-label<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)}<#if (params.for)?has_content> for="${(params.for)!}"</#if>>
    ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}
  </label>
  </#local><#if (params.isPageHeading)?? && params.isPageHeading>
  <h1 class="govuk-label-wrapper">
    ${labelHtml?markup_string?trim?no_esc}
  </h1>
  <#else>
  ${labelHtml?markup_string?trim?no_esc}
  </#if>
  </#if>
  
</#macro>

<#function govukLabel params>
  <#local result><@govukLabelMacro params=params/></#local>
  <#return result>
</#function>