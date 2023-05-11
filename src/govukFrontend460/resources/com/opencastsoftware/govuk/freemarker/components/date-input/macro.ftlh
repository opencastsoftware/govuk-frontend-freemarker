<#macro govukDateInputMacro params><#include "./template.ftlh"></#macro>
<#function govukDateInput params>
  <#assign result><@govukDateInputMacro params=params/></#assign>
  <#return result>
</#function>
