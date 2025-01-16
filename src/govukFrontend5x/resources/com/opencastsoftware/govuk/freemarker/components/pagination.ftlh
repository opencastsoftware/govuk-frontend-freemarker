<#macro _arrowLinkMacro link freeVars type="next"><#local caller><#nested/></#local><#if freeVars.arrowPrevious??><#local arrowPrevious=freeVars.arrowPrevious></#if><#if freeVars.arrowNext??><#local arrowNext=freeVars.arrowNext></#if><#if freeVars.blockLevel??><#local blockLevel=freeVars.blockLevel></#if>   <#local arrowType=(type == "prev")?then(arrowPrevious, arrowNext)>   <div class="govuk-pagination__${type}">     <a class="govuk-link govuk-pagination__link" href="${link.href}" rel="${type}"${attributes.govukAttributes(((link.attributes)!{}))}>       <#if (blockLevel)?? && blockLevel || type == "prev">${arrowType?no_esc}       </#if>       <span class="govuk-pagination__link-title<#if (blockLevel)?? && blockLevel && !((link.labelText)?has_content)> govuk-pagination__link-title--decorated</#if>">         ${caller?markup_string?trim?no_esc}       </span>       <#if (link.labelText)?has_content && (blockLevel)?? && blockLevel>       <span class="govuk-visually-hidden">:</span>       <span class="govuk-pagination__link-label">${(link.labelText)!}</span>       </#if>       <#if !((blockLevel)?? && blockLevel) && type == "next">${arrowType?no_esc}       </#if>     </a>   </div> </#macro>
<#function _arrowLink link freeVars type="next">
  <#local result><@_arrowLinkMacro link=link freeVars=freeVars type=type/></#local>
  <#return result>
</#function>

<#macro _pageItemMacro item><#local caller><#nested/></#local><li class="govuk-pagination__item<#if (item.current)?? && item.current> govuk-pagination__item--current</#if><#if (item.ellipsis)?? && item.ellipsis> govuk-pagination__item--ellipses</#if>">   <#if (item.ellipsis)?? && item.ellipsis>     &ctdot;   <#else>     <a class="govuk-link govuk-pagination__link" href="${item.href}" aria-label="${(item.visuallyHiddenText)!("Page " + item.number)}"<#if (item.current)?? && item.current> aria-current="page"</#if>${attributes.govukAttributes(((item.attributes)!{}))}>       ${(item.number)!}     </a>   </#if>   </li></#macro>
<#function _pageItem item>
  <#local result><@_pageItemMacro item=item/></#local>
  <#return result>
</#function>

<#macro govukPaginationMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local blockLevel=!((params.items)??) && ((params.next)?? || (params.previous)??)><#local arrowPrevious>
    <svg class="govuk-pagination__icon govuk-pagination__icon--prev" xmlns="http://www.w3.org/2000/svg" height="13" width="15" aria-hidden="true" focusable="false" viewBox="0 0 15 13">
      <path d="m6.5938-0.0078125-6.7266 6.7266 6.7441 6.4062 1.377-1.449-4.1856-3.9768h12.896v-2h-12.984l4.2931-4.293-1.414-1.414z"></path>
    </svg></#local><#local arrowNext>
    <svg class="govuk-pagination__icon govuk-pagination__icon--next" xmlns="http://www.w3.org/2000/svg" height="13" width="15" aria-hidden="true" focusable="false" viewBox="0 0 15 13">
      <path d="m8.107-0.0078125-1.4136 1.414 4.2926 4.293h-12.986v2h12.896l-4.1855 3.9766 1.377 1.4492 6.7441-6.4062-6.7246-6.7266z"></path>
    </svg></#local><nav class="govuk-pagination<#if (blockLevel)?? && blockLevel> govuk-pagination--block</#if><#if (params.classes)?has_content> ${(params.classes)!}</#if>" aria-label="${((params.landmarkLabel)?has_content)?then(params.landmarkLabel, "Pagination")}"${attributes.govukAttributes(((params.attributes)!{}))}>
    <#local previous=((params.previous)!{})>
    <#local next=((params.next)!{})><#if (previous)?? && (previous.href)?has_content>
      <@_arrowLinkMacro link=previous freeVars={ "arrowPrevious": arrowPrevious, "arrowNext": arrowNext } + ((blockLevel)??)?then({ "blockLevel": blockLevel }, {}) type="prev">
        <#if (previous.html)?has_content || (previous.text)?has_content>
          ${((previous.html)?has_content)?then(previous.html?no_esc?markup_string?trim?no_esc, (previous.text)!)}
        <#else>
          Previous<span class="govuk-visually-hidden"> page</span>
        </#if>
      </@_arrowLinkMacro></#if><#if (params.items)??>
    <ul class="govuk-pagination__list">
    <#list params.items![] as item>
      ${_pageItem(item)?no_esc}
    </#list>
    </ul>
    </#if><#if (next)?? && (next.href)?has_content>
      <@_arrowLinkMacro link=next freeVars={ "arrowPrevious": arrowPrevious, "arrowNext": arrowNext } + ((blockLevel)??)?then({ "blockLevel": blockLevel }, {}) type="next">
        <#if (next.html)?has_content || (next.text)?has_content>
          ${((next.html)?has_content)?then(next.html?no_esc?markup_string?trim?no_esc, (next.text)!)}
        <#else>
          Next<span class="govuk-visually-hidden"> page</span>
        </#if>
      </@_arrowLinkMacro>
    </#if>
  </nav>
  
</#macro>

<#function govukPagination params>
  <#local result><@govukPaginationMacro params=params/></#local>
  <#return result>
</#function>