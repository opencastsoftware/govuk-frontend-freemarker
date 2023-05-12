<strong class="govuk-tag<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  ${((params.html)??)?then(params.html?no_esc, params.text)}
</strong>
