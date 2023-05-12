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
</#if>
  <textarea class="govuk-textarea${((params.errorMessage)??)?then(" govuk-textarea--error", "")}${((params.classes)??)?then(" " + params.classes, "")}" id="${params.id}" name="${params.name}" rows="<#if (params.rows)??>${params.rows}<#else>5</#if>"<#if ((params.spellcheck == false))?? || ((params.spellcheck == true))??> spellcheck="${(params.spellcheck?c)}"</#if><#if params.disabled> disabled</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#if (params.autocomplete)??> autocomplete="${params.autocomplete}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${params.value}</textarea>
</div>
