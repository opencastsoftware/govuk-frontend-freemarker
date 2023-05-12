<#assign caller><#nested/></#assign caller>
<div class="govuk-error-summary<#if (params.classes)??> ${params.classes}</#if>"<#if (params.disableAutoFocus)?? && params.disableAutoFocus> data-disable-auto-focus="${(params.disableAutoFocus?c)}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list> data-module="govuk-error-summary">
  
  <div role="alert">
    <h2 class="govuk-error-summary__title">
      ${((params.titleHtml)??)?then(params.titleHtml?no_esc, params.titleText)}
    </h2>
    <div class="govuk-error-summary__body">
      <#if (caller)?? || (params.descriptionHtml)?? || (params.descriptionText)??>
        <p>
          ${((caller)??)?then(caller, (((params.descriptionHtml)??)?then(params.descriptionHtml?no_esc, params.descriptionText)))}
        </p>
      </#if>
      <ul class="govuk-list govuk-error-summary__list">
        <#list params.errorList as item>
          <li>
          <#if (item.href)??>
            <a href="${item.href}"<#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${((item.html)??)?then(item.html?no_esc, item.text)}</a>
          <#else>
            ${((item.html)??)?then(item.html?no_esc, item.text)}
          </#if>
          </li>
        </#list>
      </ul>
    </div>
  </div>
</div>
