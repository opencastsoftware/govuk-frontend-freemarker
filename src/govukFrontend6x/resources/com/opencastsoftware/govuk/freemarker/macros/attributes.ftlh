<#macro govukAttributesMacro attributes>
  <#local attributesHtml=(attributes?is_string || attributes?is_markup_output)?then(attributes, "")>
  <#if (attributes)?is_hash>
    <#list attributes as name, value>
      <#local options=(value?? && value?is_hash)?then(value, { "value": value, "optional": false })>
      <#-- It's an optional attribute with value `true` -->
      <#if (options.optional?? && options.optional?is_boolean && options.optional) && (options.value?? && options.value?is_boolean && options.value)>
        <#local attributesHtml=attributesHtml + " " + name>
      <#elseif
        <#-- It's an optional attribute whose value is not `false` -->
        (options.optional?? && options.optional?is_boolean && options.optional && options.value?? && !(options.value?is_boolean && !options.value)) ||
        <#-- It's a required attribute -->
        !(options.optional?? && options.optional?is_boolean && options.optional)>
        <#local attributesHtml=attributesHtml + " " + name + '="'?no_esc + options.value + '"'?no_esc>
      </#if>
    </#list>
  </#if>${attributesHtml?no_esc}
</#macro>

<#function govukAttributes attributes>
  <#local result><@govukAttributesMacro attributes=attributes/></#local>
  <#return result>
</#function>
