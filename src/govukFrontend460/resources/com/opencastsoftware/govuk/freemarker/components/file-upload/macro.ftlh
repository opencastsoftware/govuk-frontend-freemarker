<#macro govukFileUploadMacro params><#include "./template.ftlh"></#macro>
<#function govukFileUpload params>
  <#assign result><@govukFileUploadMacro params=params/></#assign>
  <#return result>
</#function>
