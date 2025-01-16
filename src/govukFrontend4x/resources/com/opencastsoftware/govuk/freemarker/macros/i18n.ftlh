<#macro govukPluralisedI18nAttributesMacro translationKey pluralForms><#local caller><#nested/></#local>   <#list pluralForms as pluralType, message> data-i18n.${(translationKey)!}.${pluralType}="${message}"</#list> </#macro>
<#function govukPluralisedI18nAttributes translationKey pluralForms>
  <#local result><@govukPluralisedI18nAttributesMacro translationKey=translationKey pluralForms=pluralForms/></#local>
  <#return result>
</#function>