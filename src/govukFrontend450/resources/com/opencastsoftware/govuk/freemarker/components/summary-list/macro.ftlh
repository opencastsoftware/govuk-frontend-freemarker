<#macro govukSummaryListMacro params><#include "./template.ftlh"></#macro>
<#function govukSummaryList params>
  <#assign result><@govukSummaryListMacro params=params/></#assign>
  <#return result>
</#function>
