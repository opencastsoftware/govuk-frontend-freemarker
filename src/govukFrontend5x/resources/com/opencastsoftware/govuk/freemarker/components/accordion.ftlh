<#macro _accordionItemMacro params item index><#local caller><#nested/></#local><#local headingLevel=((params.headingLevel != 0) && (!params.headingLevel?is_nan))?then(((params.headingLevel)!0), 2)>   <div class="govuk-accordion__section<#if (item.expanded)?? && item.expanded> govuk-accordion__section--expanded</#if>">     <div class="govuk-accordion__section-header">       <h${((headingLevel)!0)} class="govuk-accordion__section-heading">         <span class="govuk-accordion__section-button" id="${params.id}-heading-${index}">           ${((item.heading.html)?has_content)?then(item.heading.html?no_esc?markup_string?trim?no_esc, (item.heading.text)!)}         </span>       </h${((headingLevel)!0)}>       <#if (item.summary.html)?has_content || (item.summary.text)?has_content>       <div class="govuk-accordion__section-summary govuk-body" id="${params.id}-summary-${index}">         ${((item.summary.html)?has_content)?then(item.summary.html?no_esc?markup_string?trim?no_esc, (item.summary.text)!)}       </div>       </#if>     </div>     <div id="${params.id}-content-${index}" class="govuk-accordion__section-content">     <#if (item.content.html)?has_content>       ${item.content.html?no_esc?markup_string?trim?no_esc}     <#elseif (item.content.text)?has_content>       <p class="govuk-body">         ${item.content.text?trim}       </p>     </#if>     </div>   </div> </#macro>
<#function _accordionItem params item index>
  <#local result><@_accordionItemMacro params=params item=item index=index/></#local>
  <#return result>
</#function>

<#macro govukAccordionMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "../macros/i18n.ftlh" as i18n><div class="govuk-accordion<#if (params.classes)?has_content> ${(params.classes)!}</#if>" data-module="govuk-accordion" id="${params.id}"${i18n.govukI18nAttributes({ "key": "hide-all-sections" } + ((params.hideAllSectionsText)??)?then({ "message": params.hideAllSectionsText }, {}))}${i18n.govukI18nAttributes({ "key": "hide-section" } + ((params.hideSectionText)??)?then({ "message": params.hideSectionText }, {}))}${i18n.govukI18nAttributes({ "key": "hide-section-aria-label" } + ((params.hideSectionAriaLabelText)??)?then({ "message": params.hideSectionAriaLabelText }, {}))}${i18n.govukI18nAttributes({ "key": "show-all-sections" } + ((params.showAllSectionsText)??)?then({ "message": params.showAllSectionsText }, {}))}${i18n.govukI18nAttributes({ "key": "show-section" } + ((params.showSectionText)??)?then({ "message": params.showSectionText }, {}))}${i18n.govukI18nAttributes({ "key": "show-section-aria-label" } + ((params.showSectionAriaLabelText)??)?then({ "message": params.showSectionAriaLabelText }, {}))}<#if (params.rememberExpanded)??> data-remember-expanded="${params.rememberExpanded}"</#if>${attributes.govukAttributes(((params.attributes)!{}))}>
    <#list params.items as item>
      <#if (item)??>${_accordionItem(params, item, item?counter)}</#if>
    </#list>
  </div>
  
</#macro>

<#function govukAccordion params>
  <#local result><@govukAccordionMacro params=params/></#local>
  <#return result>
</#function>