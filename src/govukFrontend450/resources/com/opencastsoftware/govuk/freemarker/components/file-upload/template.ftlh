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
</#if>
  <input class="govuk-file-upload<#if (params.classes)?has_content> ${params.classes}</#if><#if (params.errorMessage)??> govuk-file-upload--error</#if>" id="${params.id}" name="${params.name}" type="file"<#if (params.value)?has_content> value="${params.value}"</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
</div>
