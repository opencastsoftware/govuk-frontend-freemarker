<#macro govukSelectMacro params><#include "./template.ftlh"></#macro>
<#function govukSelect params>
  <#assign result><@govukSelectMacro params=params/></#assign>
  <#return result>
</#function>
