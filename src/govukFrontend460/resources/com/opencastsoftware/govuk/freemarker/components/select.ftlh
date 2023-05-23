<#macro govukSelectMacro params>
  <#import "./error-message.ftlh" as errorMessage><#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local describedBy=((params.describedBy)?has_content)?then(params.describedBy, "")>
  <div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${params.formGroup.classes}</#if>">
    ${label.govukLabel({ "html": params.label.html, "text": params.label.text, "for": params.id } + (params.label.classes)?then({ "classes": params.label.classes }, {}) + (params.label.isPageHeading)?then({ "isPageHeading": params.label.isPageHeading }, {}) + (params.label.attributes)?then({ "attributes": params.label.attributes }, {}))?trim}
  <#if (params.hint)??>
    <#local hintId=params.id + "-hint">
    <#local describedBy=((describedBy)??)?then(describedBy + " " + hintId, hintId)>
    ${hint.govukHint({ "html": params.hint.html, "text": params.hint.text } + (hintId)?then({ "id": hintId }, {}) + (params.hint.classes)?then({ "classes": params.hint.classes }, {}) + (params.hint.attributes)?then({ "attributes": params.hint.attributes }, {}))?trim}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=params.id + "-error">
    <#local describedBy=((describedBy)??)?then(describedBy + " " + errorId, errorId)>
    ${errorMessage.govukErrorMessage({ "html": params.errorMessage.html, "text": params.errorMessage.text } + (errorId)?then({ "id": errorId }, {}) + (params.errorMessage.classes)?then({ "classes": params.errorMessage.classes }, {}) + (params.errorMessage.attributes)?then({ "attributes": params.errorMessage.attributes }, {}) + (params.errorMessage.visuallyHiddenText)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?trim}
  </#if>
    <select class="govuk-select<#if (params.classes)?has_content> ${params.classes}</#if><#if (params.errorMessage)??> govuk-select--error</#if>" id="${params.id}" name="${params.name}"<#if (params.disabled)?? && params.disabled> disabled</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <#list params.items as item>
      <#if (item)??>
        <option value="${item.value}"${((item.selected!((params.value)?has_content && (item.value == params.value)??))??)?then(" selected", "")}${((item.disabled)?? && item.disabled)?then(" disabled", "")}<#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${item.text}</option>
      </#if>
    </#list>
    </select>
  </div>
  
</#macro>

<#function govukSelect params>
  <#local result><@govukSelectMacro params=params/></#local>
  <#return result>
</#function>