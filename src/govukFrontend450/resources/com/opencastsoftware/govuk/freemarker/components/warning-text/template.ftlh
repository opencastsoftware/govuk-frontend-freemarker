<div class="govuk-warning-text${((params.classes)??)?then(" " + params.classes, "")}"<#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
  <strong class="govuk-warning-text__text">
    <span class="govuk-warning-text__assistive">${params.iconFallbackText}</span>
    ${((params.html)??)?then(params.html?no_esc, params.text)}
  </strong>
</div>
