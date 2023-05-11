<#macro govukAccordionMacro params><#include "./template.ftlh"></#macro>
<#function govukAccordion params>
  <#assign result><@govukAccordionMacro params=params/></#assign>
  <#return result>
</#function>
