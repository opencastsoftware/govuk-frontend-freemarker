<#macro govukErrorSummaryMacro params>
  <#local caller><#nested/></#local>
  <#import "../macros/attributes.ftlh" as attributes><div class="govuk-error-summary<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#if (params.disableAutoFocus)??> data-disable-auto-focus="${(params.disableAutoFocus)!false}"</#if>${attributes.govukAttributes(params.attributes)} data-module="govuk-error-summary">
    <div role="alert">
      <h2 class="govuk-error-summary__title">
        ${((params.titleHtml)?has_content)?then(params.titleHtml?no_esc?markup_string?trim?no_esc, (params.titleText)!)}
      </h2>
      <div class="govuk-error-summary__body">
        <#if (caller)?has_content || (params.descriptionHtml)?has_content || (params.descriptionText)?has_content>
        <p>
          ${((caller)?has_content)?then(caller, (((params.descriptionHtml)?has_content)?then(params.descriptionHtml?no_esc?markup_string?trim?no_esc, (params.descriptionText)!)))}
        </p>
        </#if>
        <#if (params.errorList?size != 0) && (!params.errorList?size?is_nan)>
          <ul class="govuk-list govuk-error-summary__list">
          <#list params.errorList![] as item>
            <li>
            <#if (item.href)?has_content>
              <a href="${(item.href)!}"${attributes.govukAttributes(item.attributes)}>${((item.html)?has_content)?then(item.html?no_esc?markup_string?trim?no_esc, (item.text)!)}</a>
            <#else>
              ${((item.html)?has_content)?then(item.html?no_esc?markup_string?trim?no_esc, (item.text)!)}
            </#if>
            </li>
          </#list>
          </ul>
        </#if>
      </div>
    </div>
  </div>
  
</#macro>

<#function govukErrorSummary params>
  <#local result><@govukErrorSummaryMacro params=params/></#local>
  <#return result>
</#function>