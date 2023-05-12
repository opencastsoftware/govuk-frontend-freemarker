<#assign caller><#nested/></#assign caller>
<details<#if (params.id)??> id="${params.id}"</#if> class="govuk-details<#if (params.classes)??> ${params.classes}</#if>" data-module="govuk-details"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>${(params.open)?then(" open", "")}>
  <summary class="govuk-details__summary">
    <span class="govuk-details__summary-text">
      ${((params.summaryHtml)??)?then(params.summaryHtml?no_esc, params.summaryText)}
    </span>
  </summary>
  <div class="govuk-details__text">
    ${((caller)??)?then(caller, (((params.html)??)?then(params.html?no_esc, params.text)))}
  </div>
</details>
