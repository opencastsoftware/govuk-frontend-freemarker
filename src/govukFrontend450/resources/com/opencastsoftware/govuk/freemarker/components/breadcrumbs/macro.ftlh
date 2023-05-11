<#macro govukBreadcrumbsMacro params><#include "./template.ftlh"></#macro>
<#function govukBreadcrumbs params>
  <#assign result><@govukBreadcrumbsMacro params=params/></#assign>
  <#return result>
</#function>
