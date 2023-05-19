<#assign id=params.id>
<#assign headingLevel=((params.headingLevel != 0) && (!params.headingLevel?is_nan))?then(params.headingLevel, 2)>

<div class="govuk-accordion<#if (params.classes)?has_content> ${params.classes}</#if>" data-module="govuk-accordion" id="${id}"<#if (params.hideAllSectionsText)?has_content> data-i18n.hide-all-sections="${params.hideAllSectionsText}"</#if><#if (params.hideSectionText)?has_content> data-i18n.hide-section="${params.hideSectionText}"</#if><#if (params.hideSectionAriaLabelText)?has_content> data-i18n.hide-section-aria-label="${params.hideSectionAriaLabelText}"</#if><#if (params.showAllSectionsText)?has_content> data-i18n.show-all-sections="${params.showAllSectionsText}"</#if><#if (params.showSectionText)?has_content> data-i18n.show-section="${params.showSectionText}"</#if><#if (params.showSectionAriaLabelText)?has_content> data-i18n.show-section-aria-label="${params.showSectionAriaLabelText}"</#if><#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <#list params.items as item>
    <#if (item)??>
      <div class="govuk-accordion__section<#if (item.expanded)?? && item.expanded> govuk-accordion__section--expanded</#if>">
        <div class="govuk-accordion__section-header">
          <h${headingLevel} class="govuk-accordion__section-heading">
            <span class="govuk-accordion__section-button" id="${id}-heading-${item?counter}">
              ${((item.heading.html)?has_content)?then(item.heading.html?no_esc, item.heading.text)}
            </span>
          </h${headingLevel}>
          <#if (item.summary.html)?has_content || (item.summary.text)?has_content>
            <div class="govuk-accordion__section-summary govuk-body" id="${id}-summary-${item?counter}">
              ${((item.summary.html)?has_content)?then(item.summary.html?no_esc, item.summary.text)}
            </div>
          </#if>
        </div>
        <div id="${id}-content-${item?counter}" class="govuk-accordion__section-content" aria-labelledby="${id}-heading-${item?counter}">
          <#if (item.content.html)?has_content>
            ${item.content.html?no_esc}
          <#elseif (item.content.text)?has_content>
            <p class="govuk-body">${item.content.text}</p>
          </#if>
        </div>
      </div>
    </#if>
  </#list>
</div>
