<#macro govukSelectMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local describedBy=((params.describedBy)?has_content)?then(params.describedBy, "")>
  <div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${params.formGroup.classes}</#if>">
    ${label.govukLabel({ "html": params.label.html, "text": params.label.text, "classes": params.label.classes, "isPageHeading": params.label.isPageHeading, "attributes": params.label.attributes, "for": params.id })?trim}
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
    <select class="govuk-select<#if (params.classes)?has_content> ${params.classes}</#if><#if (params.errorMessage)??> govuk-select--error</#if>" id="${params.id}" name="${params.name}"<#if (describedBy)??> aria-describedby="${describedBy}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <#list params.items as item>
      <#if (item)??>
        <option value="${item.value}"${((item.selected!(params.value)?has_content && (item.value == params.value)??)??)?then(" selected", "")}${((item.disabled)?? && item.disabled)?then(" disabled", "")}<#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${item.text}</option>
      </#if>
    </#list>
    </select>
  </div>
  
</#macro>

<#function govukSelect params>
  <#local result><@govukSelectMacro params=params/></#local>
  <#return result>
</#function>