<#macro _actionLinkMacro action>
  <a class="govuk-link<#if (action.classes)??> ${action.classes}</#if>" href="${action.href}"<#list action.attributes![] as attribute, value> ${attribute}="${value}"</#list>>
    ${((action.html)??)?then(action.html?no_esc, action.text)}<#if (action.visuallyHiddenText)??><span class="govuk-visually-hidden"> ${action.visuallyHiddenText}</span>
    </#if></a>
</#macro>
    <#function _actionLink action>
      <#assign result><@_actionLinkMacro action=action/></#assign>
      <#return result>
    </#function><#macro _summaryCardMacro params><#assign headingLevel=((params.title.headingLevel)??)?then(params.title.headingLevel, 2)><div class="govuk-summary-card<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <div class="govuk-summary-card__title-wrapper"><#if (params.title)??><h${headingLevel} class="govuk-summary-card__title<#if (params.title.classes)??> ${params.title.classes}</#if>">${((params.title.html)??)?then(params.title.html?no_esc, params.title.text)}</h${headingLevel}></#if><#if (params.actions.items.length)??><#if (params.actions.items.length == 1)??><div class="govuk-summary-card__actions<#if (params.actions.classes)??> ${params.actions.classes}</#if>">${_actionLink(params.actions.items.0)}</div><#else><ul class="govuk-summary-card__actions<#if (params.actions.classes)??> ${params.actions.classes}</#if>"><#list params.actions.items![] as action><li class="govuk-summary-card__action">${_actionLink(action)}</li></#list></ul>
        </#if></#if></div>

    <div class="govuk-summary-card__content">${caller}</div>
  </div>
</#macro>
    <#function _summaryCard params>
      <#assign result><@_summaryCardMacro params=params/></#assign>
      <#return result>
    </#function>
<#assign anyRowHasActions=false>
<#list params.rows as row>
  <#assign anyRowHasActions=((row.actions.items?size)??)?then(true, anyRowHasActions)>
</#list><#assign summaryList>
  <dl class="govuk-summary-list<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
    <#list params.rows as row>
      <#if (row)??>
        <div class="govuk-summary-list__row<#if (anyRowHasActions)?? && (!row.actions.items)??> govuk-summary-list__row--no-actions</#if><#if (row.classes)??> ${row.classes}</#if>">
          <dt class="govuk-summary-list__key<#if (row.key.classes)??> ${row.key.classes}</#if>">
            ${((row.key.html)??)?then(row.key.html?no_esc, row.key.text)}
          </dt>
          <dd class="govuk-summary-list__value<#if (row.value.classes)??> ${row.value.classes}</#if>">
            ${((row.value.html)??)?then(row.value.html?trim?no_esc, row.value.text)}
          </dd>
          <#if (row.actions.items.length)??>
            <dd class="govuk-summary-list__actions<#if (row.actions.classes)??> ${row.actions.classes}</#if>">
              <#if (row.actions.items.length == 1)??>
                ${_actionLink(row.actions.items.0)?trim}
              <#else>
                <ul class="govuk-summary-list__actions-list"><#list row.actions.items![] as action><li class="govuk-summary-list__actions-list-item">${_actionLink(action)?trim}</li></#list></ul>
              </#if>
            </dd>
          </#if>
        </div>
      </#if>
    </#list>
  </dl></#assign><#if (params.card)??><@_summaryCardMacro params=params.card>${summaryList?markup_string?no_esc}</@_summaryCardMacro><#else>${summaryList?markup_string?no_esc}</#if>
