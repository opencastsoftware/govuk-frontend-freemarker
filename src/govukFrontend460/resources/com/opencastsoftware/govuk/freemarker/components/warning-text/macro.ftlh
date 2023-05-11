<#macro govukWarningTextMacro params><#include "./template.ftlh"></#macro>
<#function govukWarningText params>
  <#assign result><@govukWarningTextMacro params=params/></#assign>
  <#return result>
</#function>
