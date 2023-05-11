<#macro govukPaginationMacro params><#include "./template.ftlh"></#macro>
<#function govukPagination params>
  <#assign result><@govukPaginationMacro params=params/></#assign>
  <#return result>
</#function>
