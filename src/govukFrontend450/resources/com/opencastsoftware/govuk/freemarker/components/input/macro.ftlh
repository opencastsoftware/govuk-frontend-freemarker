<#macro govukInputMacro params><#include "./template.ftlh"></#macro>
<#function govukInput params>
  <#assign result><@govukInputMacro params=params/></#assign>
  <#return result>
</#function>
