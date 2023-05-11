<#import "../error-message/macro.ftlh" as errorMessage><#import "../hint/macro.ftlh" as hint>
<#import "../label/macro.ftlh" as label><#assign describedBy=((params.describedBy)??)?then(params.describedBy, "")>
<div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)??> ${params.formGroup.classes}</#if>">
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
</#if><#if (params.prefix)?? || (params.suffix)??><div class="govuk-input__wrapper"></#if><#if (params.prefix.text)?? || (params.prefix.html)??><div class="govuk-input__prefix${((params.prefix.classes)??)?then(" " + params.prefix.classes, "")}" aria-hidden="true"<#list params.prefix.attributes as attribute, value> ${attribute}="${value}"</#list>>${((params.prefix.html)??)?then(params.prefix.html?no_esc, params.prefix.text)}</div>
  </#if><input class="govuk-input<#if (params.classes)??> ${params.classes}</#if><#if (params.errorMessage)??> govuk-input--error</#if>" id="${params.id}" name="${params.name}" type="${params.type!"text"}"<#if ((params.spellcheck == false))?? || ((params.spellcheck == true))??> spellcheck="${(params.spellcheck?c)}"</#if><#if (params.value)??> value="${params.value}"</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#if (params.autocomplete)??> autocomplete="${params.autocomplete}"</#if><#if (params.pattern)??> pattern="${params.pattern}"</#if><#if (params.inputmode)??> inputmode="${params.inputmode}"</#if><#list params.attributes as attribute, value> ${attribute}="${value}"</#list>><#if (params.suffix.text)?? || (params.suffix.html)??><div class="govuk-input__suffix${((params.suffix.classes)??)?then(" " + params.suffix.classes, "")}" aria-hidden="true"<#list params.suffix.attributes as attribute, value> ${attribute}="${value}"</#list>>${((params.suffix.html)??)?then(params.suffix.html?no_esc, params.suffix.text)}</div>
  </#if><#if (params.prefix)?? || (params.suffix)??></div></#if>

</div>
