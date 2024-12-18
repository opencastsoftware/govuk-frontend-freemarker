<#macro govukDetailsMacro params>
  <#local caller><#nested/></#local>
  <#import "../macros/attributes.ftlh" as attributes><details<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-details<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)}${((params.open)?? && params.open)?then(" open", "")}>
    <summary class="govuk-details__summary">
      <span class="govuk-details__summary-text">
        ${((params.summaryHtml)?has_content)?then(params.summaryHtml?no_esc?markup_string?trim?no_esc, (params.summaryText)!)}
      </span>
    </summary>
    <div class="govuk-details__text">
      ${((caller)?has_content)?then(caller, (((params.html)?has_content)?then(params.html?no_esc, (params.text)!)))}
    </div>
  </details>
  
</#macro>

<#function govukDetails params>
  <#local result><@govukDetailsMacro params=params/></#local>
  <#return result>
</#function>