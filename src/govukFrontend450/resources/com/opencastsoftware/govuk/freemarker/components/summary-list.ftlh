<#macro _actionLinkMacro action><#local caller><#nested/></#local>   <a class="govuk-link<#if (action.classes)?has_content> ${(action.classes)!}</#if>" href="${action.href}"<#list action.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>     ${((action.html)?has_content)?then(action.html?no_esc, (action.text)!)}<#if (action.visuallyHiddenText)?has_content><span class="govuk-visually-hidden"> ${(action.visuallyHiddenText)!}</span>     </#if></a> </#macro>
<#function _actionLink action>
  <#local result><@_actionLinkMacro action=action/></#local>
  <#return result>
</#function>

<#macro _summaryCardMacro params><#local caller><#nested/></#local><#local headingLevel=((params.title.headingLevel != 0) && (!params.title.headingLevel?is_nan))?then(params.title.headingLevel, 2)><div class="govuk-summary-card<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>     <div class="govuk-summary-card__title-wrapper"><#if (params.title)??><h${(headingLevel)!0} class="govuk-summary-card__title<#if (params.title.classes)?has_content> ${(params.title.classes)!}</#if>">${((params.title.html)?has_content)?then(params.title.html?no_esc, (params.title.text)!)}</h${(headingLevel)!0}></#if><#if ((params.actions.items)?? && (params.actions.items)?size gt 0)><#if params.actions.items?size == 1><div class="govuk-summary-card__actions<#if (params.actions.classes)?has_content> ${(params.actions.classes)!}</#if>">${_actionLink(params.actions.items[0])}</div><#else><ul class="govuk-summary-card__actions<#if (params.actions.classes)?has_content> ${(params.actions.classes)!}</#if>"><#list params.actions.items![] as action><li class="govuk-summary-card__action">${_actionLink(action)}</li></#list></ul>         </#if></#if></div>      <div class="govuk-summary-card__content">${caller}</div>   </div> </#macro>
<#function _summaryCard params>
  <#local result><@_summaryCardMacro params=params/></#local>
  <#return result>
</#function>

<#macro govukSummaryListMacro params>
  
  <#local anyRowHasActions=false>
  <#list params.rows as row>
    <#local anyRowHasActions=((row.actions.items?size != 0) && (!row.actions.items?size?is_nan))?then(true, anyRowHasActions)>
  </#list><#local summaryList>
    <dl class="govuk-summary-list<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
      <#list params.rows as row>
        <#if (row)??>
          <div class="govuk-summary-list__row<#if (anyRowHasActions)?? && anyRowHasActions && !((row.actions.items)??)> govuk-summary-list__row--no-actions</#if><#if (row.classes)?has_content> ${(row.classes)!}</#if>">
            <dt class="govuk-summary-list__key<#if (row.key.classes)?has_content> ${(row.key.classes)!}</#if>">
              ${((row.key.html)?has_content)?then(row.key.html?no_esc, (row.key.text)!)}
            </dt>
            <dd class="govuk-summary-list__value<#if (row.value.classes)?has_content> ${(row.value.classes)!}</#if>">
              ${((row.value.html)?has_content)?then(row.value.html?trim?no_esc, (row.value.text)!)}
            </dd>
            <#if ((row.actions.items)?? && (row.actions.items)?size gt 0)>
              <dd class="govuk-summary-list__actions<#if (row.actions.classes)?has_content> ${(row.actions.classes)!}</#if>">
                <#if row.actions.items?size == 1>
                  ${_actionLink(row.actions.items[0])?markup_string?trim?no_esc}
                <#else>
                  <ul class="govuk-summary-list__actions-list"><#list row.actions.items![] as action><li class="govuk-summary-list__actions-list-item">${_actionLink(action)?markup_string?trim?no_esc}</li></#list></ul>
                </#if>
              </dd>
            </#if>
          </div>
        </#if>
      </#list>
    </dl></#local><#if (params.card)??><@_summaryCardMacro params=params.card>${summaryList?no_esc}</@_summaryCardMacro><#else>${summaryList?no_esc}</#if>
  
</#macro>

<#function govukSummaryList params>
  <#local result><@govukSummaryListMacro params=params/></#local>
  <#return result>
</#function>