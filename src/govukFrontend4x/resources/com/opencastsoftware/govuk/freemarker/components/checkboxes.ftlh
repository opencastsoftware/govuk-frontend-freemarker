<#macro govukCheckboxesMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./fieldset.ftlh" as fieldset>
  <#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local idPrefix=((params.idPrefix)?has_content)?then((params.idPrefix)!, params.name)><#local describedBy=((params.describedBy)?has_content)?then((params.describedBy)!, "")>
  <#if (params.fieldset.describedBy)?has_content>
    <#local describedBy=(params.fieldset.describedBy)!>
  </#if><#local hasFieldset=((params.fieldset)??)?then(true, false)><#local innerHtml>
  <#if (params.hint)??>
    <#local hintId=idPrefix + "-hint">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + hintId, (hintId)!)>
    ${hint.govukHint(((hintId)??)?then({ "id": hintId }, {}) + ((params.hint.classes)??)?then({ "classes": params.hint.classes }, {}) + ((params.hint.attributes)??)?then({ "attributes": params.hint.attributes }, {}) + ((params.hint.html)??)?then({ "html": params.hint.html }, {}) + ((params.hint.text)??)?then({ "text": params.hint.text }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=idPrefix + "-error">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + errorId, (errorId)!)>
    ${errorMessage.govukErrorMessage(((errorId)??)?then({ "id": errorId }, {}) + ((params.errorMessage.classes)??)?then({ "classes": params.errorMessage.classes }, {}) + ((params.errorMessage.attributes)??)?then({ "attributes": params.errorMessage.attributes }, {}) + ((params.errorMessage.html)??)?then({ "html": params.errorMessage.html }, {}) + ((params.errorMessage.text)??)?then({ "text": params.errorMessage.text }, {}) + ((params.errorMessage.visuallyHiddenText)??)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?markup_string?trim?no_esc}
  </#if>
    <div class="govuk-checkboxes<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>
      data-module="govuk-checkboxes">
      <#list params.items as item>
        <#if (item)??><#if (item.id)?has_content><#local id=(item.id)!><#else><#if item?is_first><#local id=(idPrefix)!>
            <#else><#local id=idPrefix + "-" + item?counter></#if></#if><#local name=((item.name)?has_content)?then((item.name)!, params.name)>
          <#local conditionalId="conditional-" + id><#if (item.divider)?has_content>
            <div class="govuk-checkboxes__divider">${(item.divider)!}</div><#else>
            <#local isChecked=(item.checked)!((params.values)?? && (params.values)?seq_contains(item.value))>
            <#local hasHint=((item.hint.text)?has_content || (item.hint.html)?has_content)?then(true, false)>
            <#local itemHintId=((hasHint)?? && hasHint)?then(id + "-item-hint", "")>
            <#local itemDescribedBy=(!((hasFieldset)?? && hasFieldset))?then((describedBy)!, "")>
            <#local itemDescribedBy=(itemDescribedBy + " " + itemHintId)?trim>
            <div class="govuk-checkboxes__item">
              <input class="govuk-checkboxes__input" id="${(id)!}" name="${(name)!}" type="checkbox" value="${item.value}"${((isChecked)?? && isChecked)?then(" checked", "")}${((item.disabled)?? && item.disabled)?then(" disabled", "")}<#if (item.conditional.html)?has_content> data-aria-controls="${(conditionalId)!}"</#if><#if (item.behaviour)?has_content> data-behaviour="${(item.behaviour)!}"</#if><#if (itemDescribedBy)?has_content> aria-describedby="${(itemDescribedBy)!}"</#if><#list item.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>
              ${label.govukLabel({ "classes": "govuk-checkboxes__label" + (((item.label.classes)?has_content)?then(" " + item.label.classes, "")) } + ((item.html)??)?then({ "html": item.html }, {}) + ((item.text)??)?then({ "text": item.text }, {}) + ((item.label.attributes)??)?then({ "attributes": item.label.attributes }, {}) + ((id)??)?then({ "for": id }, {}))?markup_string?trim?no_esc}
              <#if (hasHint)?? && hasHint>
              ${hint.govukHint({ "classes": "govuk-checkboxes__hint" + (((item.hint.classes)?has_content)?then(" " + item.hint.classes, "")) } + ((itemHintId)??)?then({ "id": itemHintId }, {}) + ((item.hint.attributes)??)?then({ "attributes": item.hint.attributes }, {}) + ((item.hint.html)??)?then({ "html": item.hint.html }, {}) + ((item.hint.text)??)?then({ "text": item.hint.text }, {}))?markup_string?trim?no_esc}
              </#if>
            </div>
            <#if (item.conditional.html)?has_content>
              <div class="govuk-checkboxes__conditional<#if !((isChecked)?? && isChecked)> govuk-checkboxes__conditional--hidden</#if>" id="${(conditionalId)!}">
                ${item.conditional.html?no_esc}
              </div>
            </#if>
          </#if>
        </#if>
      </#list>
    </div>
  </#local><div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>">
  <#if (params.fieldset)??>
    <@fieldset.govukFieldsetMacro params=((describedBy)??)?then({ "describedBy": describedBy }, {}) + ((params.fieldset.classes)??)?then({ "classes": params.fieldset.classes }, {}) + ((params.fieldset.attributes)??)?then({ "attributes": params.fieldset.attributes }, {}) + ((params.fieldset.legend)??)?then({ "legend": params.fieldset.legend }, {})>
    ${innerHtml?markup_string?trim?no_esc?no_esc}
    </@fieldset.govukFieldsetMacro>
  <#else>
    ${innerHtml?markup_string?trim?no_esc?no_esc}
  </#if>
  </div>
  
</#macro>

<#function govukCheckboxes params>
  <#local result><@govukCheckboxesMacro params=params/></#local>
  <#return result>
</#function>