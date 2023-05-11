<#macro govukInsetTextMacro params><#include "./template.ftlh"></#macro>
<#function govukInsetText params>
  <#assign result><@govukInsetTextMacro params=params/></#assign>
  <#return result>
</#function>
