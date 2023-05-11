<#if (params.html)?? || (params.text)??>
<#assign labelHtml>
<label class="govuk-label<#if (params.classes)??> ${params.classes}</#if>"<#list params.attributes as attribute, value> ${attribute}="${value}"</#list><#if (params.for)??> for="${params.for}"</#if>>
  ${((params.html)??)?then(params.html?no_esc, params.text)}
</label>
</#assign>

<#if params.isPageHeading>
<h1 class="govuk-label-wrapper">${labelHtml?markup_string?no_esc}</h1>
<#else>
${labelHtml?markup_string?no_esc}
</#if>
</#if>
