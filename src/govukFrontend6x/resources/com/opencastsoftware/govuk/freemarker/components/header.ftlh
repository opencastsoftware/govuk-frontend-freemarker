<#macro govukHeaderMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#import "../macros/logo.ftlh" as logo><div class="govuk-header<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    <div class="govuk-header__container ${((params.containerClasses)?has_content)?then(params.containerClasses, "govuk-width-container")}">
      <div class="govuk-header__logo">
        <a href="${((params.homepageUrl)?has_content)?then(params.homepageUrl, "//gov.uk")}" class="govuk-header__homepage-link">
          ${logo.govukLogo({ "classes": "govuk-header__logotype", "ariaLabelText": "GOV.UK" })?markup_string?trim?no_esc}
          <#if ((params.productName)?has_content)>
          <span class="govuk-header__product-name">${(params.productName)!}</span>
          </#if>
        </a>
      </div>
    </div>
  </div>
  
</#macro>

<#function govukHeader params>
  <#local result><@govukHeaderMacro params=params/></#local>
  <#return result>
</#function>