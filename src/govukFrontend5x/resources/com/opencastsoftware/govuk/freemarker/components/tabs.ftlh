<#macro _tabListItemMacro params item index><#local caller><#nested/></#local> <#local tabPanelId=((item.id)?has_content)?then(item.id, idPrefix + "-" + index)><li class="govuk-tabs__list-item<#if index == 1> govuk-tabs__list-item--selected</#if>">   <a class="govuk-tabs__tab" href="#${(tabPanelId)!}"${attributes.govukAttributes(item.attributes)}>     ${item.label}   </a> </li> </#macro>
<#function _tabListItem params item index>
  <#local result><@_tabListItemMacro params=params item=item index=index/></#local>
  <#return result>
</#function>

<#macro _tabPanelMacro params item index><#local caller><#nested/></#local> <#local tabPanelId=((item.id)?has_content)?then(item.id, idPrefix + "-" + index)><div class="govuk-tabs__panel<#if index gt 1> govuk-tabs__panel--hidden</#if>" id="${(tabPanelId)!}"${attributes.govukAttributes(item.panel.attributes)}> <#if (item.panel.html)?has_content>   ${item.panel.html?no_esc?markup_string?trim?no_esc} <#elseif (item.panel.text)?has_content>   <p class="govuk-body">${(item.panel.text)!}</p> </#if> </div> </#macro>
<#function _tabPanel params item index>
  <#local result><@_tabPanelMacro params=params item=item index=index/></#local>
  <#return result>
</#function>

<#macro govukTabsMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local idPrefix=((params.idPrefix)?has_content)?then(params.idPrefix, "")><div<#if (params.id)?has_content> id="${(params.id)!}"</#if> class="govuk-tabs<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(params.attributes)} data-module="govuk-tabs">
    <h2 class="govuk-tabs__title">
      ${params.title!("Contents")}
    </h2>
  <#if (params.items?size != 0) && (!params.items?size?is_nan)>
    <ul class="govuk-tabs__list">
      <#list params.items as item>
        <#if (item)??>${_tabListItem(params, item, item?counter)?markup_string?trim?no_esc}
        </#if>
      </#list>
    </ul>
    <#list params.items as item>
      <#if (item)??>${_tabPanel(params, item, item?counter)?markup_string?trim?no_esc}
      </#if>
    </#list>
  </#if>
  </div>
  
</#macro>

<#function govukTabs params>
  <#local result><@govukTabsMacro params=params/></#local>
  <#return result>
</#function>