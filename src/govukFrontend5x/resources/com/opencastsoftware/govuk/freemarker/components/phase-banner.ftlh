<#macro govukPhaseBannerMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./tag.ftlh" as tag><div class="govuk-phase-banner<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    <p class="govuk-phase-banner__content">
      ${tag.govukTag({ "classes": "govuk-phase-banner__content__tag" + (((params.tag.classes)?has_content)?then(" " + params.tag.classes, "")) } + ((params.tag.text)??)?then({ "text": params.tag.text }, {}) + ((params.tag.html)??)?then({ "html": params.tag.html }, {}))?markup_string?trim?no_esc}
      <span class="govuk-phase-banner__text">
        ${((params.html)?has_content)?then(params.html?no_esc?markup_string?trim?no_esc, (params.text)!)}
      </span>
    </p>
  </div>
  
</#macro>

<#function govukPhaseBanner params>
  <#local result><@govukPhaseBannerMacro params=params/></#local>
  <#return result>
</#function>