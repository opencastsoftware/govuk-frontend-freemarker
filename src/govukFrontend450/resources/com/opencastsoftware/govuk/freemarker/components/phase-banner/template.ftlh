<#import "../tag/macro.ftlh" as tag><div class="govuk-phase-banner<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
  <p class="govuk-phase-banner__content">
    ${tag.govukTag({ "text": params.tag.text, "html": params.tag.html, "classes": "govuk-phase-banner__content__tag" + (((params.tag.classes)??)?then(" " + params.tag.classes, "")) })?trim}
    <span class="govuk-phase-banner__text">
      ${((params.html)?has_content)?then(params.html?no_esc, params.text)}
    </span>
  </p>
</div>
