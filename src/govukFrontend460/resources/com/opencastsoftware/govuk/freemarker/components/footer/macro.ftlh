<#macro govukFooterMacro params><#include "./template.ftlh"></#macro>
<#function govukFooter params>
  <#assign result><@govukFooterMacro params=params/></#assign>
  <#return result>
</#function>
