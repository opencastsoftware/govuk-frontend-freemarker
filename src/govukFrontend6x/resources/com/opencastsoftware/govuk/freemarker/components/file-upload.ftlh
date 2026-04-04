<#macro govukFileUploadMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "../macros/i18n.ftlh" as i18n>
  <#import "./error-message.ftlh" as errorMessage>
  <#import "./hint.ftlh" as hint>
  <#import "./label.ftlh" as label><#local describedBy=((params.describedBy)?has_content)?then((params.describedBy)!, "")><#local id=((params.id)?has_content)?then((params.id)!, params.name)><div class="govuk-form-group<#if (params.errorMessage)??> govuk-form-group--error</#if><#if (params.formGroup.classes)?has_content> ${(params.formGroup.classes)!}</#if>"${attributes.govukAttributes(((params.formGroup.attributes)!{}))}>
    ${label.govukLabel(((params.label.html)??)?then({ "html": params.label.html }, {}) + ((params.label.text)??)?then({ "text": params.label.text }, {}) + ((params.label.classes)??)?then({ "classes": params.label.classes }, {}) + ((params.label.isPageHeading)??)?then({ "isPageHeading": params.label.isPageHeading }, {}) + ((params.label.attributes)??)?then({ "attributes": params.label.attributes }, {}) + ((id)??)?then({ "for": id }, {}))?markup_string?trim?no_esc}
  <#if (params.hint)??>
    <#local hintId=id + "-hint">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + hintId, (hintId)!)>
    ${hint.govukHint(((hintId)??)?then({ "id": hintId }, {}) + ((params.hint.classes)??)?then({ "classes": params.hint.classes }, {}) + ((params.hint.attributes)??)?then({ "attributes": params.hint.attributes }, {}) + ((params.hint.html)??)?then({ "html": params.hint.html }, {}) + ((params.hint.text)??)?then({ "text": params.hint.text }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.errorMessage)??>
    <#local errorId=id + "-error">
    <#local describedBy=((describedBy)?has_content)?then(describedBy + " " + errorId, (errorId)!)>
    ${errorMessage.govukErrorMessage(((errorId)??)?then({ "id": errorId }, {}) + ((params.errorMessage.classes)??)?then({ "classes": params.errorMessage.classes }, {}) + ((params.errorMessage.attributes)??)?then({ "attributes": params.errorMessage.attributes }, {}) + ((params.errorMessage.html)??)?then({ "html": params.errorMessage.html }, {}) + ((params.errorMessage.text)??)?then({ "text": params.errorMessage.text }, {}) + ((params.errorMessage.visuallyHiddenText)??)?then({ "visuallyHiddenText": params.errorMessage.visuallyHiddenText }, {}))?markup_string?trim?no_esc}
  </#if>
  <#if (params.formGroup.beforeInput)??>
    ${((params.formGroup.beforeInput.html)?has_content)?then(params.formGroup.beforeInput.html?no_esc?markup_string?trim?no_esc, (params.formGroup.beforeInput.text)!)}
  </#if>
  <#if (params.javascript)?? && params.javascript>
    <div
      class="govuk-drop-zone"
      data-module="govuk-file-upload"${i18n.govukI18nAttributes({ "key": "choose-files-button" } + ((params.chooseFilesButtonText)??)?then({ "message": params.chooseFilesButtonText }, {}))}${i18n.govukI18nAttributes({ "key": "no-file-chosen" } + ((params.noFileChosenText)??)?then({ "message": params.noFileChosenText }, {}))}${i18n.govukI18nAttributes({ "key": "multiple-files-chosen" } + ((params.multipleFilesChosenText)??)?then({ "messages": params.multipleFilesChosenText }, {}))}${i18n.govukI18nAttributes({ "key": "drop-instruction" } + ((params.dropInstructionText)??)?then({ "message": params.dropInstructionText }, {}))}${i18n.govukI18nAttributes({ "key": "entered-drop-zone" } + ((params.enteredDropZoneText)??)?then({ "message": params.enteredDropZoneText }, {}))}${i18n.govukI18nAttributes({ "key": "left-drop-zone" } + ((params.leftDropZoneText)??)?then({ "message": params.leftDropZoneText }, {}))}>
  </#if>
    <input class="govuk-file-upload<#if (params.classes)?has_content> ${(params.classes)!}</#if><#if (params.errorMessage)??> govuk-file-upload--error</#if>" id="${(id)!}" name="${params.name}" type="file"<#if (params.disabled)?? && params.disabled> disabled</#if><#if (params.multiple)?? && params.multiple> multiple</#if><#if (describedBy)?has_content> aria-describedby="${(describedBy)!}"</#if>${attributes.govukAttributes(((params.attributes)!{}))}>
  <#if (params.javascript)?? && params.javascript>
    </div>
  </#if>
  <#if (params.formGroup.afterInput)??>
    ${((params.formGroup.afterInput.html)?has_content)?then(params.formGroup.afterInput.html?no_esc?markup_string?trim?no_esc, (params.formGroup.afterInput.text)!)}
  </#if>
  </div>
  
</#macro>

<#function govukFileUpload params>
  <#local result><@govukFileUploadMacro params=params/></#local>
  <#return result>
</#function>