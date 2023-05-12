<#import "../error-message/macro.ftlh" as errorMessage><#import "../fieldset/macro.ftlh" as fieldset>
<#import "../hint/macro.ftlh" as hint>
<#import "../label/macro.ftlh" as label><#assign idPrefix=((params.idPrefix)??)?then(params.idPrefix, params.name)><#assign describedBy=((params.fieldset.describedBy)??)?then(params.fieldset.describedBy, "")><#assign innerHtml>
<#if (params.hint)??>
  <#assign hintId=idPrefix + "-hint">
  <#assign describedBy=((describedBy)??)?then(describedBy + " " + hintId, hintId)>
  ${hint.govukHint({ "id": hintId, "classes": params.hint.classes, "attributes": params.hint.attributes, "html": params.hint.html, "text": params.hint.text })?trim}
</#if>
<#if (params.errorMessage)??>
  <#assign errorId=idPrefix + "-error">
  <#assign describedBy=((describedBy)??)?then(describedBy + " " + errorId, errorId)>
  ${errorMessage.govukErrorMessage({ "id": errorId, "classes": params.errorMessage.classes, "attributes": params.errorMessage.attributes, "html": params.errorMessage.html, "text": params.errorMessage.text, "visuallyHiddenText": params.errorMessage.visuallyHiddenText })?trim}
</#if>
  <div class="govuk-radios<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>
    data-module="govuk-radios">
    <#list params.items as item>
      <#if (item)??><#if (item.id)??><#assign id=item.id><#else><#if (item?is_first)??><#assign id=idPrefix>
          <#else><#assign id=idPrefix + "-" + item?counter></#if></#if><#assign conditionalId="conditional-" + id><#if (item.divider)??>
        <div class="govuk-radios__divider">${item.divider}</div><#else>
        <#assign isChecked=(item.checked?c)!params.value && item.value == params.value>
        <#assign hasHint=((item.hint.text)?? || (item.hint.html)??)?then(true, "")>
        <#assign itemHintId=id + "-item-hint">
        <div class="govuk-radios__item">
          <input class="govuk-radios__input" id="${id}" name="${params.name}" type="radio" value="${item.value}"${((isChecked)??)?then(" checked", "")}${(item.disabled)?then(" disabled", "")}<#if (item.conditional.html)??> data-aria-controls="${conditionalId}"</#if><#if (hasHint)??> aria-describedby="${itemHintId}"</#if><#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
          ${label.govukLabel({ "html": item.html, "text": item.text, "classes": "govuk-radios__label" + (((item.label.classes)??)?then(" " + item.label.classes, "")), "attributes": item.label.attributes, "for": id })?trim}
          <#if (hasHint)??>
          ${hint.govukHint({ "id": itemHintId, "classes": "govuk-radios__hint" + (((item.hint.classes)??)?then(" " + item.hint.classes, "")), "attributes": item.hint.attributes, "html": item.hint.html, "text": item.hint.text })?trim}
          </#if>
        </div>
        <#if (item.conditional.html)??>
          <div class="govuk-radios__conditional<#if (!isChecked)??> govuk-radios__conditional--hidden</#if>" id="${conditionalId}">
            ${item.conditional.html?no_esc}
          </div>
        </#if>
        </#if>
      </#if>
    </#list>
  </div>
</#assign><div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)??> ${params.formGroup.classes}</#if>">
<#if (params.fieldset)??>
  <@fieldset.govukFieldsetMacro params={ "describedBy": describedBy, "classes": params.fieldset.classes, "attributes": params.fieldset.attributes, "legend": params.fieldset.legend }>
  ${innerHtml?markup_string?trim?no_esc}
  </@fieldset.govukFieldsetMacro>
<#else>
  ${innerHtml?markup_string?trim?no_esc}
</#if>
</div>
