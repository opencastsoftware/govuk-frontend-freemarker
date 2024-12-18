<#macro govukExitThisPageMacro params>
  <#import "./button.ftlh" as button><div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-exit-this-page<#if (params.classes)?has_content> ${(params.classes)!}</#if>" data-module="govuk-exit-this-page"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list><#if (params.activatedText)?has_content> data-i18n.activated="${params.activatedText}"</#if><#if (params.timedOutText)?has_content> data-i18n.timed-out="${params.timedOutText}"</#if><#if (params.pressTwoMoreTimesText)?has_content> data-i18n.press-two-more-times="${params.pressTwoMoreTimesText}"</#if><#if (params.pressOneMoreTimeText)?has_content> data-i18n.press-one-more-time="${params.pressOneMoreTimeText}"</#if>
  >${button.govukButton({ "text": params.text!("Exit this page"), "classes": "govuk-button--warning govuk-exit-this-page__button govuk-js-exit-this-page-button", "href": params.redirectUrl!("https://www.bbc.co.uk/weather") } + ((params.html)??)?then({ "html": params.html }, {}))}</div>
  
</#macro>

<#function govukExitThisPage params>
  <#local result><@govukExitThisPageMacro params=params/></#local>
  <#return result>
</#function>