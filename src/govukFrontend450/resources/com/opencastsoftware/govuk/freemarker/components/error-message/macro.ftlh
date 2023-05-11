<#macro govukErrorMessageMacro params><#include "./template.ftlh"></#macro>
<#function govukErrorMessage params>
  <#assign result><@govukErrorMessageMacro params=params/></#assign>
  <#return result>
</#function>
