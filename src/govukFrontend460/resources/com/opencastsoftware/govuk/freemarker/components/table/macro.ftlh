<#macro govukTableMacro params><#include "./template.ftlh"></#macro>
<#function govukTable params>
  <#assign result><@govukTableMacro params=params/></#assign>
  <#return result>
</#function>
