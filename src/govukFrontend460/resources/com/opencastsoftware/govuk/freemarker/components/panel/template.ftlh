<#assign caller><#nested/></#assign caller>
<#assign headingLevel=((params.headingLevel)??)?then(params.headingLevel, 1)>
<div class="govuk-panel govuk-panel--confirmation<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <h${headingLevel} class="govuk-panel__title">
    ${((params.titleHtml)??)?then(params.titleHtml?no_esc, params.titleText)}
  </h${headingLevel}>
  <#if (caller)?? || (params.html)?? || (params.text)??>
  <div class="govuk-panel__body">
    ${((caller)??)?then(caller, (((params.html)??)?then(params.html?no_esc, params.text)))}
  </div>
  </#if>
</div>
