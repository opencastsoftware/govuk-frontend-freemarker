<#macro govukErrorSummaryMacro params><#include "./template.ftlh"></#macro>
<#function govukErrorSummary params>
  <#assign result><@govukErrorSummaryMacro params=params/></#assign>
  <#return result>
</#function>
