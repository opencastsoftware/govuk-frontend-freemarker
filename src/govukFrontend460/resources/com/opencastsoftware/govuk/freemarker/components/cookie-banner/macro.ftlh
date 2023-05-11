<#macro govukCookieBannerMacro params><#include "./template.ftlh"></#macro>
<#function govukCookieBanner params>
  <#assign result><@govukCookieBannerMacro params=params/></#assign>
  <#return result>
</#function>
