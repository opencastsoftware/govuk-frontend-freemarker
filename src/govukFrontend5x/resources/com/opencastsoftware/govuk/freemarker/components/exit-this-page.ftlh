<#macro govukExitThisPageMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./button.ftlh" as button><#local defaultHtml>
    <span class="govuk-visually-hidden">Emergency</span> Exit this page
  </#local><div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-exit-this-page<#if (params.classes)?has_content> ${(params.classes)!}</#if>" data-module="govuk-exit-this-page"${attributes.govukAttributes(params.attributes)}<#if (params.activatedText)?has_content> data-i18n.activated="${params.activatedText}"</#if><#if (params.timedOutText)?has_content> data-i18n.timed-out="${params.timedOutText}"</#if><#if (params.pressTwoMoreTimesText)?has_content> data-i18n.press-two-more-times="${params.pressTwoMoreTimesText}"</#if><#if (params.pressOneMoreTimeText)?has_content> data-i18n.press-one-more-time="${params.pressOneMoreTimeText}"</#if>
  >
    ${button.govukButton({ "html": (((params.html)?has_content || (params.text)?has_content))?then(params.html, defaultHtml), "classes": "govuk-button--warning govuk-exit-this-page__button govuk-js-exit-this-page-button", "href": ((params.redirectUrl)?has_content)?then(params.redirectUrl, "https://www.bbc.co.uk/weather"), "attributes": { "rel": "nofollow noreferrer" } } + ((params.text)??)?then({ "text": params.text }, {}))?markup_string?trim?no_esc}
  </div>
  
</#macro>

<#function govukExitThisPage params>
  <#local result><@govukExitThisPageMacro params=params/></#local>
  <#return result>
</#function>