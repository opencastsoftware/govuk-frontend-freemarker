<#macro _startIconMacro ><#local caller><#nested/></#local>   <svg class="govuk-button__start-icon" xmlns="http://www.w3.org/2000/svg" width="17.5" height="19" viewBox="0 0 33 40" aria-hidden="true" focusable="false">     <path fill="currentColor" d="M0 0h13l20 20-20 20H0l20-20z"/>   </svg></#macro>
<#function _startIcon >
  <#local result><@_startIconMacro /></#local>
  <#return result>
</#function>

<#macro govukButtonMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local classNames="govuk-button"><#if (params.classes)?has_content>
    <#local classNames=classNames + " " + params.classes>
  </#if><#if (params.isStartButton)?? && params.isStartButton>
    <#local classNames=classNames + " govuk-button--start">
  </#if><#if (params.element)?has_content>
    <#local element=params.element?lower_case>
  <#else>
    <#if (params.href)?has_content>
      <#local element="a">
    <#else>
      <#local element="button">
    </#if>
  </#if><#local commonAttributes> class="${(classNames)!}" data-module="govuk-button"${attributes.govukAttributes(params.attributes)}<#if (params.id)?has_content> id="${(params.id)!}"</#if></#local><#local buttonAttributes><#if (params.name)?has_content> name="${(params.name)!}"</#if><#if (params.disabled)?? && params.disabled> disabled aria-disabled="true"</#if><#if (params.preventDoubleClick)??> data-prevent-double-click="${(params.preventDoubleClick)!false}"</#if></#local><#if (element)! == "a">
  <a href="${((params.href)?has_content)?then((params.href)!, "#")}" role="button" draggable="false"${commonAttributes?no_esc}>
    ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}${((params.isStartButton)?? && params.isStartButton)?then(_startIcon()?no_esc, "")}
  </a><#elseif (element)! == "button">
  <button<#if (params.value)?has_content> value="${(params.value)!}"</#if> type="${((params.type)?has_content)?then((params.type)!, "submit")}"${buttonAttributes?no_esc}${commonAttributes?no_esc}>
    ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}${((params.isStartButton)?? && params.isStartButton)?then(_startIcon()?no_esc, "")}
  </button><#elseif (element)! == "input">
  <input value="${(params.text)!}" type="${((params.type)?has_content)?then((params.type)!, "submit")}"${buttonAttributes?no_esc}${commonAttributes?no_esc}></#if>
  
</#macro>

<#function govukButton params>
  <#local result><@govukButtonMacro params=params/></#local>
  <#return result>
</#function>