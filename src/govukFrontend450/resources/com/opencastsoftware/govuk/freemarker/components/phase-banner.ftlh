<#macro govukPhaseBannerMacro params>
  <#import "./tag.ftlh" as tag><div class="govuk-phase-banner<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <p class="govuk-phase-banner__content">
      ${tag.govukTag({ "text": params.tag.text, "html": params.tag.html } + ("govuk-phase-banner__content__tag" + (((params.tag.classes)?has_content)?then(" " + params.tag.classes, "")))?then({ "classes": "govuk-phase-banner__content__tag" + (((params.tag.classes)?has_content)?then(" " + params.tag.classes, "")) }, {}))?trim}
      <span class="govuk-phase-banner__text">
        ${((params.html)?has_content)?then(params.html?no_esc, params.text)}
      </span>
    </p>
  </div>
  
</#macro>

<#function govukPhaseBanner params>
  <#local result><@govukPhaseBannerMacro params=params/></#local>
  <#return result>
</#function>