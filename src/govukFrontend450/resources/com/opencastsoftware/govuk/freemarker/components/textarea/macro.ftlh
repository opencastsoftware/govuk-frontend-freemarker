<#macro govukTextareaMacro params><#include "./template.ftlh"></#macro>
<#function govukTextarea params>
  <#assign result><@govukTextareaMacro params=params/></#assign>
  <#return result>
</#function>
