<#macro govukRadiosMacro params><#include "./template.ftlh"></#macro>
<#function govukRadios params>
  <#assign result><@govukRadiosMacro params=params/></#assign>
  <#return result>
</#function>
