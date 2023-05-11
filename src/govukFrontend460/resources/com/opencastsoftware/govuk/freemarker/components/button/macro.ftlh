<#macro govukButtonMacro params><#include "./template.ftlh"></#macro>
<#function govukButton params>
  <#assign result><@govukButtonMacro params=params/></#assign>
  <#return result>
</#function>
