<#macro govukCheckboxesMacro params><#include "./template.ftlh"></#macro>
<#function govukCheckboxes params>
  <#assign result><@govukCheckboxesMacro params=params/></#assign>
  <#return result>
</#function>
