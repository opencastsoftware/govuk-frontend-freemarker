<#assign visuallyHiddenText=params.visuallyHiddenText!"Error"><p<#if (params.id)??> id="${params.id}"</#if> class="govuk-error-message<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <#if (visuallyHiddenText)??><span class="govuk-visually-hidden">${visuallyHiddenText}:</span> </#if>${((params.html)??)?then(params.html?no_esc, params.text)}
</p>
