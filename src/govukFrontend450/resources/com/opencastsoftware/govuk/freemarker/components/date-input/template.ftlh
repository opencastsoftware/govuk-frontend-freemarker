<#import "../error-message/macro.ftlh" as errorMessage><#import "../fieldset/macro.ftlh" as fieldset>
<#import "../hint/macro.ftlh" as hint>
<#import "../input/macro.ftlh" as input><#assign describedBy=((params.fieldset.describedBy)??)?then(params.fieldset.describedBy, "")>

<#if (params.items?size)??>
  <#assign dateInputItems=params.items>
<#else>
  <#assign dateInputItems=[{ "name": "day", "classes": "govuk-input--width-2" }, { "name": "month", "classes": "govuk-input--width-2" }, { "name": "year", "classes": "govuk-input--width-4" }]>
</#if><#assign innerHtml>
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
  <div class="govuk-date-input<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list><#if (params.id)??> id="${params.id}"</#if>>
    <#list dateInputItems![] as item>
    <div class="govuk-date-input__item">
      ${input.govukInput({ "label": { "text": ((item.label)??)?then(item.label, item.name?capitalize), "classes": "govuk-date-input__label" }, "id": ((item.id)??)?then(item.id, (params.id + "-" + item.name)), "classes": "govuk-date-input__input " + (((item.classes)??)?then(item.classes, "")), "name": ((params.namePrefix)??)?then((params.namePrefix + "-" + item.name), item.name), "value": item.value, "type": "text", "inputmode": ((item.inputmode)??)?then(item.inputmode, "numeric"), "autocomplete": item.autocomplete, "pattern": item.pattern, "attributes": item.attributes })?trim}
    </div>
  </#list>
  </div>
</#assign>

<div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)??> ${params.formGroup.classes}</#if>">
<#if (params.fieldset)??><@fieldset.govukFieldsetMacro params={ "describedBy": describedBy, "classes": params.fieldset.classes, "role": "group", "attributes": params.fieldset.attributes, "legend": params.fieldset.legend }>
  ${innerHtml?markup_string?trim?no_esc}
  </@fieldset.govukFieldsetMacro>
<#else>
  ${innerHtml?markup_string?trim?no_esc}
</#if>
</div>
