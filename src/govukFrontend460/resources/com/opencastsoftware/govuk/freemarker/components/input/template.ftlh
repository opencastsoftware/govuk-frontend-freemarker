<#import "../error-message/macro.ftlh" as errorMessage><#import "../hint/macro.ftlh" as hint>
<#import "../label/macro.ftlh" as label><#assign describedBy=((params.describedBy)?has_content)?then(params.describedBy, "")>
<div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${params.formGroup.classes}</#if>">
  ${label.govukLabel({ "html": params.label.html, "text": params.label.text, "classes": params.label.classes, "isPageHeading": params.label.isPageHeading, "attributes": params.label.attributes, "for": params.id })?trim}
<#if (params.hint)??>
  <#assign hintId=params.id + "-hint">
  <#assign describedBy=((describedBy)??)?then(describedBy + " " + hintId, hintId)>
  ${hint.govukHint({ "id": hintId, "classes": params.hint.classes, "attributes": params.hint.attributes, "html": params.hint.html, "text": params.hint.text })?trim}
</#if>
<#if (params.errorMessage)??>
  <#assign errorId=params.id + "-error">
  <#assign describedBy=((describedBy)??)?then(describedBy + " " + errorId, errorId)>
  ${errorMessage.govukErrorMessage({ "id": errorId, "classes": params.errorMessage.classes, "attributes": params.errorMessage.attributes, "html": params.errorMessage.html, "text": params.errorMessage.text, "visuallyHiddenText": params.errorMessage.visuallyHiddenText })?trim}
</#if><#if (params.prefix)?? || (params.suffix)??><div class="govuk-input__wrapper"></#if><#if (params.prefix.text)?has_content || (params.prefix.html)?has_content><div class="govuk-input__prefix${((params.prefix.classes)?has_content)?then(" " + params.prefix.classes, "")}" aria-hidden="true"<#list params.prefix.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${((params.prefix.html)?has_content)?then(params.prefix.html?no_esc, params.prefix.text)}</div>
  </#if><input class="govuk-input<#if (params.classes)?has_content> ${params.classes}</#if><#if (params.errorMessage)??> govuk-input--error</#if>" id="${params.id}" name="${params.name}" type="${params.type!"text"}"<#if ((params.spellcheck == false))?? || ((params.spellcheck == true))??> spellcheck="${params.spellcheck}"</#if><#if (params.value)?has_content> value="${params.value}"</#if><#if (params.disabled)?? && params.disabled> disabled</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#if (params.autocomplete)?has_content> autocomplete="${params.autocomplete}"</#if><#if (params.pattern)?has_content> pattern="${params.pattern}"</#if><#if (params.inputmode)?has_content> inputmode="${params.inputmode}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>><#if (params.suffix.text)?has_content || (params.suffix.html)?has_content><div class="govuk-input__suffix${((params.suffix.classes)?has_content)?then(" " + params.suffix.classes, "")}" aria-hidden="true"<#list params.suffix.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${((params.suffix.html)?has_content)?then(params.suffix.html?no_esc, params.suffix.text)}</div>
  </#if><#if (params.prefix)?? || (params.suffix)??></div></#if>

</div>
