<#macro govukTabsMacro params><#include "./template.ftlh"></#macro>
<#function govukTabs params>
  <#assign result><@govukTabsMacro params=params/></#assign>
  <#return result>
</#function>
