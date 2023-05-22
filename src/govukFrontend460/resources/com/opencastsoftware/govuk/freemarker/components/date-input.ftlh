<#macro govukDateInputMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./fieldset.ftlh" as fieldset>
  <#import "./hint.ftlh" as hint>
  <#import "./input.ftlh" as input><#local describedBy=((params.fieldset.describedBy)??)?then(params.fieldset.describedBy, "")>
  
  <#if (params.items?size)??>
    <#local dateInputItems=params.items>
  <#else>
    <#local dateInputItems=[{ "name": "day", "classes": "govuk-input--width-2" }, { "name": "month", "classes": "govuk-input--width-2" }, { "name": "year", "classes": "govuk-input--width-4" }]>
  </#if><#local innerHtml>
  <#if (params.hint)??>
    <#local hintId=params.id + "-hint">
    <#local describedBy=((describedBy)??)?then(describedBy + " " + hintId, hintId)>
    ${hint.govukHint({ "id": hintId, "classes": params.hint.classes, "attributes": params.hint.attributes, "html": params.hint.html, "text": params.hint.text })?trim}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=params.id + "-error">
    <#local describedBy=((describedBy)??)?then(describedBy + " " + errorId, errorId)>
    ${errorMessage.govukErrorMessage({ "id": errorId, "classes": params.errorMessage.classes, "attributes": params.errorMessage.attributes, "html": params.errorMessage.html, "text": params.errorMessage.text, "visuallyHiddenText": params.errorMessage.visuallyHiddenText })?trim}
  </#if>
    <div class="govuk-date-input<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list><#if (params.id)?has_content> id="${params.id}"</#if>>
      <#list dateInputItems![] as item>
      <div class="govuk-date-input__item">
        ${input.govukInput({ "label": { "text": ((item.label)??)?then(item.label, item.name?capitalize), "classes": "govuk-date-input__label" }, "id": ((item.id)??)?then(item.id, (params.id + "-" + item.name)), "classes": "govuk-date-input__input " + (((item.classes)??)?then(item.classes, "")), "name": ((params.namePrefix)?has_content)?then((params.namePrefix + "-" + item.name), item.name), "value": item.value, "type": "text", "inputmode": ((item.inputmode)??)?then(item.inputmode, "numeric"), "autocomplete": item.autocomplete, "pattern": item.pattern, "attributes": item.attributes })?trim}
      </div>
    </#list>
    </div>
  </#local>
  
  <div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${params.formGroup.classes}</#if>">
  <#if (params.fieldset)??><@fieldset.govukFieldsetMacro params={ "describedBy": describedBy, "classes": params.fieldset.classes, "role": "group", "attributes": params.fieldset.attributes, "legend": params.fieldset.legend }>
    ${innerHtml?markup_string?trim?no_esc}
    </@fieldset.govukFieldsetMacro>
  <#else>
    ${innerHtml?markup_string?trim?no_esc}
  </#if>
  </div>
  
</#macro>

<#function govukDateInput params>
  <#local result><@govukDateInputMacro params=params/></#local>
  <#return result>
</#function>