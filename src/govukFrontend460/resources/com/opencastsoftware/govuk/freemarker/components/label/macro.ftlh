<#macro govukLabelMacro params><#include "./template.ftlh"></#macro>
<#function govukLabel params>
  <#assign result><@govukLabelMacro params=params/></#assign>
  <#return result>
</#function>
