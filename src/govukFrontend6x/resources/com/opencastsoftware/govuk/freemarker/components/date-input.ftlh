<#macro govukDateInputMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./error-message.ftlh" as errorMessage>
  <#import "./fieldset.ftlh" as fieldset>
  <#import "./hint.ftlh" as hint>
  <#import "./input.ftlh" as input><#local describedBy=((params.fieldset.describedBy)?has_content)?then((params.fieldset.describedBy)!, "")><#local hasFieldset=((params.fieldset)??)?then(true, false)><#if (params.items?size != 0) && (!params.items?size?is_nan)>
    <#local dateInputItems=((params.items)![])>
  <#else>
    <#local dateInputItems=[{ "name": "day", "classes": "govuk-input--width-2" }, { "name": "month", "classes": "govuk-input--width-2" }, { "name": "year", "classes": "govuk-input--width-4" }]>
  </#if><#local innerHtml>
  <#if (params.hint)??>
    <#local hintId=params.id + "-hint">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + hintId, (hintId)!)>
    ${hint.govukHint(((hintId)??)?then({ "id": hintId }, {}) + ((params.hint.classes)??)?then({ "classes": params.hint.classes }, {}) + ((params.hint.attributes)??)?then({ "attributes": params.hint.attributes }, {}) + ((params.hint.html)??)?then({ "html": params.hint.html }, {}) + ((params.hint.text)??)?then({ "text": params.hint.text }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=params.id + "-error">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + errorId, (errorId)!)>
    ${errorMessage.govukErrorMessage(((errorId)??)?then({ "id": errorId }, {}) + ((params.errorMessage.classes)??)?then({ "classes": params.errorMessage.classes }, {}) + ((params.errorMessage.attributes)??)?then({ "attributes": params.errorMessage.attributes }, {}) + ((params.errorMessage.html)??)?then({ "html": params.errorMessage.html }, {}) + ((params.errorMessage.text)??)?then({ "text": params.errorMessage.text }, {}) + ((params.errorMessage.visuallyHiddenText)??)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?markup_string?trim?no_esc}
  </#if>
    <div class="govuk-date-input<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}<#if (params.id)?has_content> id="${params.id}"</#if>>
      <#if (params.formGroup.beforeInputs)??>
      ${((params.formGroup.beforeInputs.html)?has_content)?then(params.formGroup.beforeInputs.html?no_esc?markup_string?trim?no_esc, (params.formGroup.beforeInputs.text)!)}
      </#if>
      <#list dateInputItems as item>
      <div class="govuk-date-input__item">
        ${input.govukInput({ "label": { "classes": "govuk-date-input__label" } + ((item.label)?has_content)?then((item.label??)?then({ "text": item.label }, {}), { "text": item.name?capitalize }), "classes": "govuk-date-input__input " + (((item.classes)?has_content)?then(item.classes, "")), "type": "text" } + ((item.id)?has_content)?then((item.id??)?then({ "id": item.id }, {}), { "id": (params.id + "-" + item.name) }) + ((params.namePrefix)?has_content)?then({ "name": (params.namePrefix + "-" + item.name) }, { "name": item.name }) + ((item.value)??)?then({ "value": item.value }, {}) + ((item.inputmode)??)?then({ "inputmode": item.inputmode }, { "inputmode": "numeric" }) + ((item.autocomplete)??)?then({ "autocomplete": item.autocomplete }, {}) + ((item.pattern)??)?then({ "pattern": item.pattern }, {}) + ((item.attributes)??)?then({ "attributes": item.attributes }, {}))?markup_string?trim?no_esc}
      </div>
      </#list>
      <#if (params.formGroup.afterInputs)??>
      ${((params.formGroup.afterInputs.html)?has_content)?then(params.formGroup.afterInputs.html?no_esc?markup_string?trim?no_esc, (params.formGroup.afterInputs.text)!)}
      </#if>
    </div>
  </#local><div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>"${attributes.govukAttributes(((params.formGroup.attributes)!{}))}>
  <#if (hasFieldset)?? && hasFieldset>
    ${fieldset.govukFieldset({ "role": "group", "html": innerHtml?markup_string?trim } + ((describedBy)??)?then({ "describedBy": describedBy }, {}) + ((params.fieldset.classes)??)?then({ "classes": params.fieldset.classes }, {}) + ((params.fieldset.attributes)??)?then({ "attributes": params.fieldset.attributes }, {}) + ((params.fieldset.legend)??)?then({ "legend": params.fieldset.legend }, {}))?markup_string?trim?no_esc}
  <#else>
    ${innerHtml?markup_string?trim?no_esc}
  </#if>
  </div>
  
</#macro>

<#function govukDateInput params>
  <#local result><@govukDateInputMacro params=params/></#local>
  <#return result>
</#function>