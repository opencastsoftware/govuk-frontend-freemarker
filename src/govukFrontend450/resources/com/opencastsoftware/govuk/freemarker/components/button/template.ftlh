<#assign classNames="govuk-button"><#if (params.classes)??>
  <#assign classNames=classNames + " " + params.classes>
</#if>
<#if params.disabled>
  <#assign classNames=classNames + " govuk-button--disabled">
</#if><#if (params.element)??>
  <#assign element=params.element?lower_case>
<#else>
  <#if (params.href)??>
    <#assign element="a">
  <#else>
    <#assign element="button">
  </#if>
</#if><#if params.isStartButton>
  <#assign iconHtml>
<svg class="govuk-button__start-icon" xmlns="http://www.w3.org/2000/svg" width="17.5" height="19" viewBox="0 0 33 40" aria-hidden="true" focusable="false">
  <path fill="currentColor" d="M0 0h13l20 20-20 20H0l20-20z"/>
</svg>
  </#assign>
  <#assign classNames=classNames + " govuk-button--start">
</#if><#assign commonAttributes> class="${classNames}" data-module="govuk-button"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list></#assign><#assign buttonAttributes><#if (params.name)??> name="${params.name}"</#if><#if params.disabled> disabled="disabled" aria-disabled="true"</#if><#if (params.preventDoubleClick)?? && params.preventDoubleClick> data-prevent-double-click="${(params.preventDoubleClick?c)}"</#if></#assign><#if (element == "a")??>
<a href="${((params.href)??)?then(params.href, "#")}" role="button" draggable="false"${commonAttributes?markup_string?no_esc}>
  ${((params.html)??)?then(params.html?no_esc, params.text)}
${((iconHtml)??)?then(iconHtml?markup_string?no_esc?trim, "")}</a><#elseif (element == "button")??>
<button<#if (params.value)??> value="${params.value}"</#if><#if (params.type)??> type="${params.type}"</#if>${buttonAttributes?markup_string?no_esc}${commonAttributes?markup_string?no_esc}>
  ${((params.html)??)?then(params.html?no_esc, params.text)}
${((iconHtml)??)?then(iconHtml?markup_string?no_esc?trim, "")}</button><#elseif (element == "input")??>
<input value="${params.text}" type="${((params.type)??)?then(params.type, "submit")}"${buttonAttributes?markup_string?no_esc}${commonAttributes?markup_string?no_esc}></#if>
