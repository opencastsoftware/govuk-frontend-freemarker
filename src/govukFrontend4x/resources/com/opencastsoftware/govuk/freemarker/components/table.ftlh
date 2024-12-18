<#macro govukTableMacro params>
  <table class="govuk-table<#if (params.classes)?has_content> ${(params.classes)!}</#if>"<#list params.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>
    <#if (params.caption)?has_content>
    <caption class="govuk-table__caption<#if (params.captionClasses)?has_content> ${(params.captionClasses)!}</#if>">${(params.caption)!}</caption>
    </#if>
    <#if (params.head)??>
    <thead class="govuk-table__head">
      <tr class="govuk-table__row">
      <#list params.head![] as item>
        <th scope="col" class="govuk-table__header<#if (item.format)?has_content> govuk-table__header--${(item.format)!}</#if><#if (item.classes)?has_content> ${(item.classes)!}</#if>"<#if (item.colspan != 0) && (!item.colspan?is_nan)> colspan="${(item.colspan)!0}"</#if><#if (item.rowspan != 0) && (!item.rowspan?is_nan)> rowspan="${(item.rowspan)!0}"</#if><#list item.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>>${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}</th>
      </#list>
      </tr>
    </thead>
    </#if>
    <tbody class="govuk-table__body">
      <#list params.rows as row>
        <#if (row)??>
          <tr class="govuk-table__row">
          <#list row as cell>
            <#local commonAttributes><#if (cell.colspan != 0) && (!cell.colspan?is_nan)> colspan="${(cell.colspan)!0}"</#if><#if (cell.rowspan != 0) && (!cell.rowspan?is_nan)> rowspan="${(cell.rowspan)!0}"</#if><#list cell.attributes!{} as attribute, value> ${(attribute)!}="${(value)!}"</#list>
            </#local>
            <#if cell?is_first && (params.firstCellIsHeader)?? && params.firstCellIsHeader>
            <th scope="row" class="govuk-table__header<#if (cell.classes)?has_content> ${(cell.classes)!}</#if>"${commonAttributes?no_esc}>${((cell.html)?has_content)?then(cell.html?no_esc, (cell.text)!)}</th>
            <#else>
            <td class="govuk-table__cell<#if (cell.format)?has_content> govuk-table__cell--${(cell.format)!}</#if><#if (cell.classes)?has_content> ${(cell.classes)!}</#if>"${commonAttributes?no_esc}>${((cell.html)?has_content)?then(cell.html?no_esc, (cell.text)!)}</td>
            </#if>
          </#list>
          </tr>
        </#if>
      </#list>
    </tbody>
  </table>
  
</#macro>

<#function govukTable params>
  <#local result><@govukTableMacro params=params/></#local>
  <#return result>
</#function>