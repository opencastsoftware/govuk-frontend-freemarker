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
  <select class="govuk-select<#if (params.classes)??> ${params.classes}</#if><#if (params.errorMessage)??> govuk-select--error</#if>" id="${params.id}" name="${params.name}"<#if params.disabled> disabled</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <#list params.items as item>
    <#if (item)??>
      <option value="${item.value}"${(((item.selected?c)!params.value && item.value == params.value)??)?then(" selected", "")}${(item.disabled)?then(" disabled", "")}<#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${item.text}</option>
    </#if>
  </#list>
  </select>
</div>
