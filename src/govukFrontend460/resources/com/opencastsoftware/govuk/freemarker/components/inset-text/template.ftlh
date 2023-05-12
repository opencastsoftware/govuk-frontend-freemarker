<#assign caller><#nested/></#assign caller>
<div<#if (params.id)??> id="${params.id}"</#if> class="govuk-inset-text<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  ${((caller)??)?then(caller, (((params.html)??)?then(params.html?no_esc, params.text)))}
</div>
