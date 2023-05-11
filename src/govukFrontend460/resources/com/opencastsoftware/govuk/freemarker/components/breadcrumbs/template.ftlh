<#assign classNames="govuk-breadcrumbs"><#if (params.classes)??>
  <#assign classNames=classNames + " " + params.classes>
</#if><#if params.collapseOnMobile>
  <#assign classNames=classNames + " govuk-breadcrumbs--collapse-on-mobile">
</#if><div class="${classNames}"<#list params.attributes as attribute, value> ${attribute}="${value}"</#list>>
  <ol class="govuk-breadcrumbs__list">
  <#list params.items as item>
    <#if (item.href)??>
    <li class="govuk-breadcrumbs__list-item">
      <a class="govuk-breadcrumbs__link" href="${item.href}"<#list item.attributes as attribute, value> ${attribute}="${value}"</#list>>${((item.html)??)?then(item.html?no_esc, item.text)}</a>
    </li>
    <#else>
    <li class="govuk-breadcrumbs__list-item" aria-current="page">${((item.html)??)?then(item.html?no_esc, item.text)}</li>
    </#if>
  </#list>
  </ol>
</div>
