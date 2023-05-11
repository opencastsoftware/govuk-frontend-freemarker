<#macro govukBackLinkMacro params><#include "./template.ftlh"></#macro>
<#function govukBackLink params>
  <#assign result><@govukBackLinkMacro params=params/></#assign>
  <#return result>
</#function>
