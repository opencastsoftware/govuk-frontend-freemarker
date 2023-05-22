<#macro govukTextareaMacro params>
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
    <textarea class="govuk-textarea${((params.errorMessage)??)?then(" govuk-textarea--error", "")}${((params.classes)?has_content)?then(" " + params.classes, "")}" id="${params.id}" name="${params.name}" rows="<#if (params.rows)?has_content>${params.rows}<#else>5</#if>"<#if ((params.spellcheck == false))?? || ((params.spellcheck == true))??> spellcheck="${params.spellcheck}"</#if><#if (params.disabled)?? && params.disabled> disabled</#if><#if (describedBy)??> aria-describedby="${describedBy}"</#if><#if (params.autocomplete)?has_content> autocomplete="${params.autocomplete}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${params.value}</textarea>
  </div>
  
</#macro>

<#function govukTextarea params>
  <#local result><@govukTextareaMacro params=params/></#local>
  <#return result>
</#function>