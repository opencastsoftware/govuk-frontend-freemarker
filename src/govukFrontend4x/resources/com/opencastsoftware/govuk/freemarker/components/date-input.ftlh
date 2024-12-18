<#macro govukDateInputMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./fieldset.ftlh" as fieldset>
  <#import "./hint.ftlh" as hint>
  <#import "./input.ftlh" as input><#local describedBy=((params.fieldset.describedBy)?has_content)?then(params.fieldset.describedBy, "")>
  
  <#if (params.items?size != 0) && (!params.items?size?is_nan)>
    <#local dateInputItems=params.items>
  <#else>
    <#local dateInputItems=[{ "name": "day", "classes": "govuk-input--width-2" }, { "name": "month", "classes": "govuk-input--width-2" }, { "name": "year", "classes": "govuk-input--width-4" }]>
  </#if><#local innerHtml>
  <#if (params.hint)??>
    <#local hintId=params.id + "-hint">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + hintId, hintId)>
    ${hint.govukHint(((hintId)??)?then({ "id": hintId }, {}) + ((params.hint.classes)??)?then({ "classes": params.hint.classes }, {}) + ((params.hint.attributes)??)?then({ "attributes": params.hint.attributes }, {}) + ((params.hint.html)??)?then({ "html": params.hint.html }, {}) + ((params.hint.text)??)?then({ "text": params.hint.text }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=params.id + "-error">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + errorId, errorId)>
    ${errorMessage.govukErrorMessage(((errorId)??)?then({ "id": errorId }, {}) + ((params.errorMessage.classes)??)?then({ "classes": params.errorMessage.classes }, {}) + ((params.errorMessage.attributes)??)?then({ "attributes": params.errorMessage.attributes }, {}) + ((params.errorMessage.html)??)?then({ "html": params.errorMessage.html }, {}) + ((params.errorMessage.text)??)?then({ "text": params.errorMessage.text }, {}) + ((params.errorMessage.visuallyHiddenText)??)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?markup_string?trim?no_esc}
  </#if>
    <div class="govuk-date-input<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list><#if (params.id)?has_content> id="${params.id}"</#if>>
      <#list dateInputItems!{} as item>
      <div class="govuk-date-input__item">
        ${input.govukInput({ "label": { "text": ((item.label)?has_content)?then(item.label, item.name?capitalize), "classes": "govuk-date-input__label" }, "id": ((item.id)?has_content)?then(item.id, (params.id + "-" + item.name)), "classes": "govuk-date-input__input " + (((item.classes)?has_content)?then(item.classes, "")), "name": ((params.namePrefix)?has_content)?then((params.namePrefix + "-" + item.name), item.name), "type": "text", "inputmode": ((item.inputmode)??)?then(item.inputmode, "numeric") } + ((item.value)??)?then({ "value": item.value }, {}) + ((item.autocomplete)??)?then({ "autocomplete": item.autocomplete }, {}) + ((item.pattern)??)?then({ "pattern": item.pattern }, {}) + ((item.attributes)??)?then({ "attributes": item.attributes }, {}))?markup_string?trim?no_esc}
      </div>
    </#list>
    </div>
  </#local>
  
  <div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>">
  <#if (params.fieldset)??><@fieldset.govukFieldsetMacro params={ "role": "group" } + ((describedBy)??)?then({ "describedBy": describedBy }, {}) + ((params.fieldset.classes)??)?then({ "classes": params.fieldset.classes }, {}) + ((params.fieldset.attributes)??)?then({ "attributes": params.fieldset.attributes }, {}) + ((params.fieldset.legend)??)?then({ "legend": params.fieldset.legend }, {})>
    ${innerHtml?markup_string?trim?no_esc?no_esc}
    </@fieldset.govukFieldsetMacro>
  <#else>
    ${innerHtml?markup_string?trim?no_esc?no_esc}
  </#if>
  </div>
  
</#macro>

<#function govukDateInput params>
  <#local result><@govukDateInputMacro params=params/></#local>
  <#return result>
</#function>