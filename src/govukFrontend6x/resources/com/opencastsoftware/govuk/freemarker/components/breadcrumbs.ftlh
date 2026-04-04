<#macro govukBreadcrumbsMacro params>
  <#import "../macros/attributes.ftlh" as attributes><#local classNames="govuk-breadcrumbs"><#if (params.classes)?has_content>
    <#local classNames=classNames + " " + params.classes>
  </#if><#if (params.collapseOnMobile)?? && params.collapseOnMobile>
    <#local classNames=classNames + " govuk-breadcrumbs--collapse-on-mobile">
  </#if><nav class="${(classNames)!}"${attributes.govukAttributes(((params.attributes)!{}))} aria-label="${(params.labelText)!("Breadcrumb")}">
    <ol class="govuk-breadcrumbs__list">
  <#list params.items as item>
    <#if (item.href)?has_content>
      <li class="govuk-breadcrumbs__list-item">
        <a class="govuk-breadcrumbs__link" href="${(item.href)!}"${attributes.govukAttributes(((item.attributes)!{}))}>${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}</a>
      </li>
    <#else>
      <li class="govuk-breadcrumbs__list-item" aria-current="page">${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}</li>
    </#if>
  </#list>
    </ol>
  </nav>
  
</#macro>

<#function govukBreadcrumbs params>
  <#local result><@govukBreadcrumbsMacro params=params/></#local>
  <#return result>
</#function>