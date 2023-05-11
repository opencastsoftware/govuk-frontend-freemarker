<#macro govukNotificationBannerMacro params><#include "./template.ftlh"></#macro>
<#function govukNotificationBanner params>
  <#assign result><@govukNotificationBannerMacro params=params/></#assign>
  <#return result>
</#function>
