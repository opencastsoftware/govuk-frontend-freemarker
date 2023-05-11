<#macro govukHintMacro params><#include "./template.ftlh"></#macro>
<#function govukHint params>
  <#assign result><@govukHintMacro params=params/></#assign>
  <#return result>
</#function>
