<#macro govukPaginationMacro params>
  <#local blockLevel=!(params.items)?? && (((params.next)?? || (params.previous)??))??>
  
  <nav class="govuk-pagination${((params.classes)?has_content)?then(" " + params.classes, "")}${((blockLevel)??)?then(" govuk-pagination--block", "")}" role="navigation" aria-label="${params.landmarkLabel!"results"}"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>><#if (params.previous)?? && (params.previous.href)?has_content><div class="govuk-pagination__prev">
        <a class="govuk-link govuk-pagination__link" href="${params.previous.href}" rel="prev"<#list params.previous.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
          <svg class="govuk-pagination__icon govuk-pagination__icon--prev" xmlns="http://www.w3.org/2000/svg" height="13" width="15" aria-hidden="true" focusable="false" viewBox="0 0 15 13">
            <path d="m6.5938-0.0078125-6.7266 6.7266 6.7441 6.4062 1.377-1.449-4.1856-3.9768h12.896v-2h-12.984l4.2931-4.293-1.414-1.414z"></path>
          </svg>
          <span class="govuk-pagination__link-title${((blockLevel)?? && !(params.previous.labelText)?has_content)?then(" govuk-pagination__link-title--decorated", "")}">${params.previous.text!"Previous"}</span><#if (params.previous.labelText)?has_content && (blockLevel)??><span class="govuk-visually-hidden">:</span>
            <span class="govuk-pagination__link-label">${params.previous.labelText}</span></#if></a>
      </div>
    </#if><#if (params.items)??><ul class="govuk-pagination__list"><#list params.items![] as item><#if (item.ellipsis)?? && item.ellipsis><li class="govuk-pagination__item govuk-pagination__item--ellipses">&ctdot;</li><#elseif (item.number)?has_content><li class="govuk-pagination__item${((item.current)?? && item.current)?then(" govuk-pagination__item--current", "")}">
              <a class="govuk-link govuk-pagination__link" href="${item.href}" aria-label="${item.visuallyHiddenText!"Page " + item.number}"<#if (item.current)?? && item.current> aria-current="page"</#if><#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
                ${item.number}
              </a>
            </li></#if></#list></ul></#if><#if (params.next)?? && (params.next.href)?has_content><#local nextArrow>
        <svg class="govuk-pagination__icon govuk-pagination__icon--next" xmlns="http://www.w3.org/2000/svg" height="13" width="15" aria-hidden="true" focusable="false" viewBox="0 0 15 13">
          <path d="m8.107-0.0078125-1.4136 1.414 4.2926 4.293h-12.986v2h12.896l-4.1855 3.9766 1.377 1.4492 6.7441-6.4062-6.7246-6.7266z"></path>
        </svg></#local><div class="govuk-pagination__next">
        <a class="govuk-link govuk-pagination__link" href="${params.next.href}" rel="next"<#list params.next.attributes!{} as attribute, value> ${attribute}="${value}"</#list>><#if (blockLevel)??>${nextArrow?markup_string?no_esc}</#if>
          <span class="govuk-pagination__link-title${((blockLevel)?? && !(params.next.labelText)?has_content)?then(" govuk-pagination__link-title--decorated", "")}">${params.next.text!"Next"}</span><#if (params.next.labelText)?has_content && (blockLevel)??><span class="govuk-visually-hidden">:</span>
            <span class="govuk-pagination__link-label">${params.next.labelText}</span></#if><#if !(blockLevel)??>${nextArrow?markup_string?no_esc}</#if></a>
      </div></#if></nav>
  
</#macro>

<#function govukPagination params>
  <#local result><@govukPaginationMacro params=params/></#local>
  <#return result>
</#function>