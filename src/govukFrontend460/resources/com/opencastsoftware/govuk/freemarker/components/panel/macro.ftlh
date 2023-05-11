<#macro govukPanelMacro params><#include "./template.ftlh"></#macro>
<#function govukPanel params>
  <#assign result><@govukPanelMacro params=params/></#assign>
  <#return result>
</#function>
