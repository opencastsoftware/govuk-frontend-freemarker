<#macro govukInputMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local describedBy=((params.describedBy)?has_content)?then((params.describedBy)!, "")>
  <div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>">
    ${label.govukLabel({ "for": params.id } + ((params.label.html)??)?then({ "html": params.label.html }, {}) + ((params.label.text)??)?then({ "text": params.label.text }, {}) + ((params.label.classes)??)?then({ "classes": params.label.classes }, {}) + ((params.label.isPageHeading)??)?then({ "isPageHeading": params.label.isPageHeading }, {}) + ((params.label.attributes)??)?then({ "attributes": params.label.attributes }, {}))?markup_string?trim?no_esc}
  <#if (params.hint)??>
    <#local hintId=params.id + "-hint">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + hintId, (hintId)!)>
    ${hint.govukHint(((hintId)??)?then({ "id": hintId }, {}) + ((params.hint.classes)??)?then({ "classes": params.hint.classes }, {}) + ((params.hint.attributes)??)?then({ "attributes": params.hint.attributes }, {}) + ((params.hint.html)??)?then({ "html": params.hint.html }, {}) + ((params.hint.text)??)?then({ "text": params.hint.text }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=params.id + "-error">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + errorId, (errorId)!)>
    ${errorMessage.govukErrorMessage(((errorId)??)?then({ "id": errorId }, {}) + ((params.errorMessage.classes)??)?then({ "classes": params.errorMessage.classes }, {}) + ((params.errorMessage.attributes)??)?then({ "attributes": params.errorMessage.attributes }, {}) + ((params.errorMessage.html)??)?then({ "html": params.errorMessage.html }, {}) + ((params.errorMessage.text)??)?then({ "text": params.errorMessage.text }, {}) + ((params.errorMessage.visuallyHiddenText)??)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?markup_string?trim?no_esc}
  </#if><#if (params.prefix)?? || (params.suffix)??><div class="govuk-input__wrapper"></#if><#if (params.prefix.text)?has_content || (params.prefix.html)?has_content><div class="govuk-input__prefix${((params.prefix.classes)?has_content)?then(" " + params.prefix.classes, "")}" aria-hidden="true"<#list params.prefix.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>${((params.prefix.html)?has_content)?then(params.prefix.html?no_esc, (params.prefix.text)!)}</div>
    </#if><input class="govuk-input<#if (params.classes)?has_content> ${(params.classes)!}</#if><#if (params.errorMessage)??> govuk-input--error</#if>" id="${params.id}" name="${params.name}" type="${(params.type)!("text")}"<#if (params.spellcheck)??> spellcheck="${((params.spellcheck)!false)}"</#if><#if (params.value)?has_content> value="${(params.value)!}"</#if><#if (params.disabled)?? && params.disabled> disabled</#if><#if (describedBy)?has_content> aria-describedby="${(describedBy)!}"</#if><#if (params.autocomplete)?has_content> autocomplete="${(params.autocomplete)!}"</#if><#if (params.pattern)?has_content> pattern="${(params.pattern)!}"</#if><#if (params.inputmode)?has_content> inputmode="${(params.inputmode)!}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>><#if (params.suffix.text)?has_content || (params.suffix.html)?has_content><div class="govuk-input__suffix${((params.suffix.classes)?has_content)?then(" " + params.suffix.classes, "")}" aria-hidden="true"<#list params.suffix.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>${((params.suffix.html)?has_content)?then(params.suffix.html?no_esc, (params.suffix.text)!)}</div>
    </#if><#if (params.prefix)?? || (params.suffix)??></div></#if>
  
  </div>
  
</#macro>

<#function govukInput params>
  <#local result><@govukInputMacro params=params/></#local>
  <#return result>
</#function>