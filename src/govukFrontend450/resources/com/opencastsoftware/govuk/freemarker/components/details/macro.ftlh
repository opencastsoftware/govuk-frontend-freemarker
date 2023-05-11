<#macro govukDetailsMacro params><#include "./template.ftlh"></#macro>
<#function govukDetails params>
  <#assign result><@govukDetailsMacro params=params/></#assign>
  <#return result>
</#function>
