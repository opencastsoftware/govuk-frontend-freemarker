<#macro _inputElementMacro params freeVars><#local caller><#nested/></#local><#if freeVars.classNames??><#local classNames=freeVars.classNames></#if><#if freeVars.describedBy??><#local describedBy=freeVars.describedBy></#if><input${attributes.govukAttributes({ "name": params.name, "type": ((params.type)?has_content)?then(params.type, "text"), "spellcheck": { "optional": true } + ((params.spellcheck)??)?then({ "value": params.spellcheck?c }, { "value": false }), "value": { "optional": true } + ((params.value)??)?then({ "value": params.value }, {}), "disabled": { "optional": true } + ((params.disabled)??)?then({ "value": params.disabled }, {}), "aria-describedby": { "optional": true } + ((describedBy)??)?then({ "value": describedBy }, {}), "autocomplete": { "optional": true } + ((params.autocomplete)??)?then({ "value": params.autocomplete }, {}), "autocapitalize": { "optional": true } + ((params.autocapitalize)??)?then({ "value": params.autocapitalize }, {}), "pattern": { "optional": true } + ((params.pattern)??)?then({ "value": params.pattern }, {}), "inputmode": { "optional": true } + ((params.inputmode)??)?then({ "value": params.inputmode }, {}) } + ((classNames)??)?then({ "class": classNames }, {}) + ((params.id)??)?then({ "id": params.id }, {}))}${attributes.govukAttributes(((params.attributes)!{}))}></#macro>
<#function _inputElement params freeVars>
  <#local result><@_inputElementMacro params=params freeVars=freeVars/></#local>
  <#return result>
</#function>

<#macro _affixItemMacro affix type><#local caller><#nested/></#local>   <div class="govuk-input__${type}<#if (affix.classes)?has_content> ${(affix.classes)!}</#if>" aria-hidden="true"${attributes.govukAttributes(((affix.attributes)!{}))}>${((affix.html)?has_content)?then(affix.html?no_esc?markup_string?trim?no_esc, (affix.text)!)}</div></#macro>
<#function _affixItem affix type>
  <#local result><@_affixItemMacro affix=affix type=type/></#local>
  <#return result>
</#function>

<#macro govukInputMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./error-message.ftlh" as errorMessage>
  <#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local classNames="govuk-input"><#if (params.classes)?has_content>
    <#local classNames=classNames + " " + params.classes>
  </#if><#if (params.errorMessage)??>
    <#local classNames=classNames + " govuk-input--error">
  </#if><#if (params.describedBy)?has_content><#local describedBy=params.describedBy></#if><#local hasPrefix=((params.prefix)?? && ((params.prefix.text)?has_content || (params.prefix.html)?has_content))?then(true, false)><#local hasSuffix=((params.suffix)?? && ((params.suffix.text)?has_content || (params.suffix.html)?has_content))?then(true, false)><#local hasBeforeInput=((params.formGroup.beforeInput)?? && ((params.formGroup.beforeInput.text)?has_content || (params.formGroup.beforeInput.html)?has_content))?then(true, false)><#local hasAfterInput=((params.formGroup.afterInput)?? && ((params.formGroup.afterInput.text)?has_content || (params.formGroup.afterInput.html)?has_content))?then(true, false)><div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>"${attributes.govukAttributes(((params.formGroup.attributes)!{}))}>
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
  </#if><#if (hasPrefix)?? && hasPrefix || (hasSuffix)?? && hasSuffix || (hasBeforeInput)?? && hasBeforeInput || (hasAfterInput)?? && hasAfterInput>
    <div class="govuk-input__wrapper<#if (params.inputWrapper.classes)?has_content> ${(params.inputWrapper.classes)!}</#if>"${attributes.govukAttributes(((params.inputWrapper.attributes)!{}))}>
      <#if (hasBeforeInput)?? && hasBeforeInput>${((params.formGroup.beforeInput.html)?has_content)?then(params.formGroup.beforeInput.html?no_esc?markup_string?trim?no_esc, (params.formGroup.beforeInput.text)!)}
      </#if>
      <#if (hasPrefix)?? && hasPrefix>${_affixItem(((params.prefix)!{}), "prefix")?no_esc}
      </#if>
      ${_inputElement(params, ((classNames)??)?then({ "classNames": classNames }, {}) + ((describedBy)??)?then({ "describedBy": describedBy }, {}))}
      <#if (hasSuffix)?? && hasSuffix>${_affixItem(((params.suffix)!{}), "suffix")?no_esc}
      </#if>
      <#if (hasAfterInput)?? && hasAfterInput>${((params.formGroup.afterInput.html)?has_content)?then(params.formGroup.afterInput.html?no_esc?markup_string?trim?no_esc, (params.formGroup.afterInput.text)!)}
      </#if>
    </div>
  <#else>
    ${_inputElement(params, ((classNames)??)?then({ "classNames": classNames }, {}) + ((describedBy)??)?then({ "describedBy": describedBy }, {}))}
  </#if>
  </div>
  
</#macro>

<#function govukInput params>
  <#local result><@govukInputMacro params=params/></#local>
  <#return result>
</#function>