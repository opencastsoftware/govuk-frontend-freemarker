<#macro govukI18nAttributesMacro params><#local caller><#nested/></#local><#if (params.messages)??><#list params.messages!{} as pluralRule, message> data-i18n.${params.key}.${(pluralRule)!}="${message}"</#list>   <#elseif (params.message)?has_content> data-i18n.${params.key}="${params.message}"</#if></#macro>
<#function govukI18nAttributes params>
  <#local result><@govukI18nAttributesMacro params=params/></#local>
  <#return result>
</#function>