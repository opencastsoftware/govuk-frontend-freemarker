<#macro govukHeaderMacro params><#include "./template.ftlh"></#macro>
<#function govukHeader params>
  <#assign result><@govukHeaderMacro params=params/></#assign>
  <#return result>
</#function>
