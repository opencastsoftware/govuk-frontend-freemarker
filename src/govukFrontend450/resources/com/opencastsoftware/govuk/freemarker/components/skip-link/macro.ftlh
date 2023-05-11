<#macro govukSkipLinkMacro params><#include "./template.ftlh"></#macro>
<#function govukSkipLink params>
  <#assign result><@govukSkipLinkMacro params=params/></#assign>
  <#return result>
</#function>
