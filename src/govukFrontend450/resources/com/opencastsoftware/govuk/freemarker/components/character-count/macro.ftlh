<#macro govukCharacterCountMacro params><#include "./template.ftlh"></#macro>
<#function govukCharacterCount params>
  <#assign result><@govukCharacterCountMacro params=params/></#assign>
  <#return result>
</#function>
