<#macro govukFieldsetMacro params><#include "./template.ftlh"></#macro>
<#function govukFieldset params>
  <#assign result><@govukFieldsetMacro params=params/></#assign>
  <#return result>
</#function>
