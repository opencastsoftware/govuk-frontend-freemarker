<#macro govukTagMacro params><#include "./template.ftlh"></#macro>
<#function govukTag params>
  <#assign result><@govukTagMacro params=params/></#assign>
  <#return result>
</#function>
