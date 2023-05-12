<table class="govuk-table<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <#if (params.caption)??>
  <caption class="govuk-table__caption<#if (params.captionClasses)??> ${params.captionClasses}</#if>">${params.caption}</caption>
  </#if>
  <#if (params.head)??>
  <thead class="govuk-table__head">
    <tr class="govuk-table__row">
    <#list params.head![] as item>
      <th scope="col" class="govuk-table__header<#if (item.format)??> govuk-table__header--${item.format}</#if><#if (item.classes)??> ${item.classes}</#if>"<#if (item.colspan)??> colspan="${item.colspan}"</#if><#if (item.rowspan)??> rowspan="${item.rowspan}"</#if><#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>${((item.html)??)?then(item.html?no_esc, item.text)}</th>
    </#list>
    </tr>
  </thead>
  </#if>
  <tbody class="govuk-table__body">
    <#list params.rows as row>
      <#if (row)??>
        <tr class="govuk-table__row">
        <#list row as cell>
          <#assign commonAttributes><#if (cell.colspan)??> colspan="${cell.colspan}"</#if><#if (cell.rowspan)??> rowspan="${cell.rowspan}"</#if><#list cell.attributes!{} as attribute, value> ${attribute}="${value}"</#list>
          </#assign>
          <#if (cell?is_first)?? && params.firstCellIsHeader>
          <th scope="row" class="govuk-table__header<#if (cell.classes)??> ${cell.classes}</#if>"${commonAttributes?markup_string?no_esc}>${((cell.html)??)?then(cell.html?no_esc, cell.text)}</th>
          <#else>
          <td class="govuk-table__cell<#if (cell.format)??> govuk-table__cell--${cell.format}</#if><#if (cell.classes)??> ${cell.classes}</#if>"${commonAttributes?markup_string?no_esc}>${((cell.html)??)?then(cell.html?no_esc, cell.text)}</td>
          </#if>
        </#list>
        </tr>
      </#if>
    </#list>
  </tbody>
</table>
