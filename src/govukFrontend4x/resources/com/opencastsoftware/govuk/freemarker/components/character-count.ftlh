<#macro govukCharacterCountMacro params>
  <#import "../macros/i18n.ftlh" as i18n>
  
  <#import "./textarea.ftlh" as textarea>
  <#import "./hint.ftlh" as hint><#local hasNoLimit=(!((params.maxwords)?has_content) && !((params.maxlength)?has_content))>
  
  <div class="govuk-character-count" data-module="govuk-character-count"<#if (params.maxlength)?has_content> data-maxlength="${params.maxlength}"</#if><#if (params.threshold)?has_content> data-threshold="${(params.threshold)!}"</#if><#if (params.maxwords)?has_content> data-maxwords="${params.maxwords}"</#if>
  <#if (hasNoLimit)?? && hasNoLimit && (params.textareaDescriptionText)?has_content>${i18n.govukPluralisedI18nAttributes("textarea-description", ((params.textareaDescriptionText)??)?then({ "other": params.textareaDescriptionText }, {}))}</#if><#if (params.charactersUnderLimitText)??>${i18n.govukPluralisedI18nAttributes("characters-under-limit", ((params.charactersUnderLimitText)!{}))}</#if><#if (params.charactersAtLimitText)?has_content> data-i18n.characters-at-limit="${params.charactersAtLimitText}"</#if><#if (params.charactersOverLimitText)??>${i18n.govukPluralisedI18nAttributes("characters-over-limit", ((params.charactersOverLimitText)!{}))}</#if><#if (params.wordsUnderLimitText)??>${i18n.govukPluralisedI18nAttributes("words-under-limit", ((params.wordsUnderLimitText)!{}))}</#if><#if (params.wordsAtLimitText)?has_content> data-i18n.words-at-limit="${params.wordsAtLimitText}"</#if><#if (params.wordsOverLimitText)??>${i18n.govukPluralisedI18nAttributes("words-over-limit", ((params.wordsOverLimitText)!{}))}</#if>>
    ${textarea.govukTextarea({ "id": params.id, "name": params.name, "describedBy": params.id + "-info", "classes": "govuk-js-character-count" + (((params.classes)?has_content)?then(" " + params.classes, "")), "label": { "for": params.id } + ((params.label.html)??)?then({ "html": params.label.html }, {}) + ((params.label.text)??)?then({ "text": params.label.text }, {}) + ((params.label.classes)??)?then({ "classes": params.label.classes }, {}) + ((params.label.isPageHeading)??)?then({ "isPageHeading": params.label.isPageHeading }, {}) + ((params.label.attributes)??)?then({ "attributes": params.label.attributes }, {}) } + ((params.rows)??)?then({ "rows": params.rows }, {}) + ((params.spellcheck)??)?then({ "spellcheck": params.spellcheck }, {}) + ((params.value)??)?then({ "value": params.value }, {}) + ((params.formGroup)??)?then({ "formGroup": params.formGroup }, {}) + ((params.hint)??)?then({ "hint": params.hint }, {}) + ((params.errorMessage)??)?then({ "errorMessage": params.errorMessage }, {}) + ((params.attributes)??)?then({ "attributes": params.attributes }, {}))}<#local textareaDescriptionLength=((params.maxwords)?has_content)?then(params.maxwords, params.maxlength)><#local textareaDescriptionText=((params.textareaDescriptionText)?has_content)?then(params.textareaDescriptionText, "You can enter up to %{count} " + (((params.maxwords)?has_content)?then("words", "characters")))>
    
    ${hint.govukHint({ "id": params.id + "-info", "classes": "govuk-character-count__message" + (((params.countMessage.classes)?has_content)?then(" " + params.countMessage.classes, "")) } + (!((hasNoLimit)?? && hasNoLimit))?then({ "text": (textareaDescriptionText)?replace("%{count}", textareaDescriptionLength) }, {}))}
  </div>
  
</#macro>

<#function govukCharacterCount params>
  <#local result><@govukCharacterCountMacro params=params/></#local>
  <#return result>
</#function>