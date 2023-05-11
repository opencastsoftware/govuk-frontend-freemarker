<#macro govukPhaseBannerMacro params><#include "./template.ftlh"></#macro>
<#function govukPhaseBanner params>
  <#assign result><@govukPhaseBannerMacro params=params/></#assign>
  <#return result>
</#function>
