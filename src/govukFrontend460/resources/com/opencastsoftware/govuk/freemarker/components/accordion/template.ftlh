<#assign id=params.id>
<#assign headingLevel=((params.headingLevel)??)?then(params.headingLevel, 2)>

<div class="govuk-accordion<#if (params.classes)??> ${params.classes}</#if>" data-module="govuk-accordion" id="${id}"<#if (params.hideAllSectionsText)??> data-i18n.hide-all-sections="${params.hideAllSectionsText}"</#if><#if (params.hideSectionText)??> data-i18n.hide-section="${params.hideSectionText}"</#if><#if (params.hideSectionAriaLabelText)??> data-i18n.hide-section-aria-label="${params.hideSectionAriaLabelText}"</#if><#if (params.showAllSectionsText)??> data-i18n.show-all-sections="${params.showAllSectionsText}"</#if><#if (params.showSectionText)??> data-i18n.show-section="${params.showSectionText}"</#if><#if (params.showSectionAriaLabelText)??> data-i18n.show-section-aria-label="${params.showSectionAriaLabelText}"</#if><#if (params.rememberExpanded)?? && params.rememberExpanded> data-remember-expanded="${(params.rememberExpanded?c)}"</#if><#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <#list params.items as item>
    <#if (item)??>
      <div class="govuk-accordion__section<#if item.expanded> govuk-accordion__section--expanded</#if>">
        <div class="govuk-accordion__section-header">
          <h${headingLevel} class="govuk-accordion__section-heading">
            <span class="govuk-accordion__section-button" id="${id}-heading-${item?counter}">
              ${((item.heading.html)??)?then(item.heading.html?no_esc, item.heading.text)}
            </span>
          </h${headingLevel}>
          <#if (item.summary.html)?? || (item.summary.text)??>
            <div class="govuk-accordion__section-summary govuk-body" id="${id}-summary-${item?counter}">
              ${((item.summary.html)??)?then(item.summary.html?no_esc, item.summary.text)}
            </div>
          </#if>
        </div>
        <div id="${id}-content-${item?counter}" class="govuk-accordion__section-content" aria-labelledby="${id}-heading-${item?counter}">
          <#if (item.content.html)??>
            ${item.content.html?no_esc}
          <#elseif (item.content.text)??>
            <p class="govuk-body">${item.content.text}</p>
          </#if>
        </div>
      </div>
    </#if>
  </#list>
</div>
