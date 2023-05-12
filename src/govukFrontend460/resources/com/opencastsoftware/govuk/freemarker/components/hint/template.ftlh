<div<#if (params.id)??> id="${params.id}"</#if> class="govuk-hint<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  ${((params.html)??)?then(params.html?no_esc, params.text)}
</div>
