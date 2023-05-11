<footer class="govuk-footer ${((params.classes)??)?then(params.classes, "")}" role="contentinfo"<#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <div class="govuk-width-container ${((params.containerClasses)??)?then(params.containerClasses, "")}">
    <#if (params.navigation?size)??>
      <div class="govuk-footer__navigation">
        <#list params.navigation as nav>
          <div class="govuk-footer__section govuk-grid-column-${nav.width!"full"}">
            <h2 class="govuk-footer__heading govuk-heading-m">${nav.title}</h2>
            <#if (nav.items?size)??>
              <#assign listClasses>
                <#if (nav.columns)??>
                  govuk-footer__list--columns-${nav.columns}
                </#if>
              </#assign>
              <ul class="govuk-footer__list ${listClasses?markup_string?trim}">
                <#list nav.items as item>
                  <#if (item.href)?? && (item.text)??>
                    <li class="govuk-footer__list-item">
                      <a class="govuk-footer__link" href="${item.href}"<#list item.attributes as attribute, value> ${attribute}="${value}"</#list>>
                        ${item.text}
                      </a>
                    </li>
                  </#if>
                </#list>
              </ul>
            </#if>
          </div>
        </#list>
      </div>
      <hr class="govuk-footer__section-break">
    </#if>
    <div class="govuk-footer__meta">
      <div class="govuk-footer__meta-item govuk-footer__meta-item--grow">
        <#if (params.meta)??>
          <h2 class="govuk-visually-hidden">${params.meta.visuallyHiddenTitle!"Support links"}</h2>
          <#if (params.meta.items?size)??>
            <ul class="govuk-footer__inline-list">
              <#list params.meta.items as item>
                <li class="govuk-footer__inline-list-item">
                  <a class="govuk-footer__link" href="${item.href}"<#list item.attributes as attribute, value> ${attribute}="${value}"</#list>>
                    ${item.text}
                  </a>
                </li>
              </#list>
            </ul>
          </#if>
          <#if (params.meta.text)?? || (params.meta.html)??>
            <div class="govuk-footer__meta-custom">
              ${((params.meta.html)??)?then(params.meta.html?no_esc, params.meta.text)}
            </div>
          </#if>
        </#if>
        <svg
          aria-hidden="true"
          focusable="false"
          class="govuk-footer__licence-logo"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 483.2 195.7"
          height="17"
          width="41"
        >
          <path
            fill="currentColor"
            d="M421.5 142.8V.1l-50.7 32.3v161.1h112.4v-50.7zm-122.3-9.6A47.12 47.12 0 0 1 221 97.8c0-26 21.1-47.1 47.1-47.1 16.7 0 31.4 8.7 39.7 21.8l42.7-27.2A97.63 97.63 0 0 0 268.1 0c-36.5 0-68.3 20.1-85.1 49.7A98 98 0 0 0 97.8 0C43.9 0 0 43.9 0 97.8s43.9 97.8 97.8 97.8c36.5 0 68.3-20.1 85.1-49.7a97.76 97.76 0 0 0 149.6 25.4l19.4 22.2h3v-87.8h-80l24.3 27.5zM97.8 145c-26 0-47.1-21.1-47.1-47.1s21.1-47.1 47.1-47.1 47.2 21 47.2 47S123.8 145 97.8 145"
          />
        </svg>
        <span class="govuk-footer__licence-description">
          <#if (params.contentLicence.html)?? || (params.contentLicence.text)??>
            ${((params.contentLicence.html)??)?then(params.contentLicence.html?no_esc, params.contentLicence.text)}
          <#else>
            All content is available under the
            <a
              class="govuk-footer__link"
              href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/"
              rel="license"
            >Open Government Licence v3.0</a>, except where otherwise stated
          </#if>
        </span>
      </div>
      <div class="govuk-footer__meta-item">
        <a
          class="govuk-footer__link govuk-footer__copyright-logo"
          href="https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/"
        ><#if (params.copyright.html)?? || (params.copyright.text)??>${((params.copyright.html)??)?then(params.copyright.html?no_esc, params.copyright.text)}<#else>© Crown copyright</#if></a>
      </div>
    </div>
  </div>
</footer>
