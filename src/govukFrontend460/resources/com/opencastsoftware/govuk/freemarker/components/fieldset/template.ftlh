<#assign caller><#nested/></#assign caller>
<fieldset class="govuk-fieldset<#if (params.classes)??> ${params.classes}</#if>"<#if (params.role)??> role="${params.role}"</#if><#if (params.describedBy)??> aria-describedby="${params.describedBy}"</#if><#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <#if (params.legend.html)?? || (params.legend.text)??>
  <legend class="govuk-fieldset__legend<#if (params.legend.classes)??> ${params.legend.classes}</#if>">
  <#if params.legend.isPageHeading>
    <h1 class="govuk-fieldset__heading">
      ${((params.legend.html)??)?then(params.legend.html?no_esc, params.legend.text)}
    </h1>
  <#else>
    ${((params.legend.html)??)?then(params.legend.html?no_esc, params.legend.text)}
  </#if>
  </legend>
  </#if>
<#if (caller)??>${caller}
<#elseif (params.html)??>
  ${params.html?no_esc}
</#if>
</fieldset>
