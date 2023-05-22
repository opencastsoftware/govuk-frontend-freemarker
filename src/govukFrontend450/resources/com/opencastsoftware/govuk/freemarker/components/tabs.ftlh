<#macro govukTabsMacro params>
  <#local idPrefix=((params.idPrefix)?has_content)?then(params.idPrefix, "")><div<#if (params.id)?has_content> id="${params.id}"</#if> class="govuk-tabs<#if (params.classes)?has_content> ${params.classes}</#if>"<#list params.attributes!{} as attribute, value> ${attribute}="${value}"</#list> data-module="govuk-tabs">
    <h2 class="govuk-tabs__title">
      ${params.title!"Contents"}
    </h2>
    <#if ((params.items?size))??>
    <ul class="govuk-tabs__list">
      <#list params.items as item>
        <#if (item)??>
          <#local id=((item.id)?has_content)?then(item.id, idPrefix + "-" + item?counter)>
          <li class="govuk-tabs__list-item<#if (item?counter == 1)??> govuk-tabs__list-item--selected</#if>">
            <a class="govuk-tabs__tab" href="#${id}"<#list item.attributes!{} as attribute, value> ${attribute}="${value}"</#list>>
              ${item.label}
            </a>
          </li>
        </#if>
      </#list>
    </ul>
    </#if>
    <#list params.items as item>
      <#if (item)??>
        <#local id=((item.id)?has_content)?then(item.id, idPrefix + "-" + item?counter)>
        <div class="govuk-tabs__panel<#if (item?counter > 1)??> govuk-tabs__panel--hidden</#if>" id="${id}"<#list item.panel.attributes![] as attribute, value> ${attribute}="${value}"</#list>>
          <#if (item.panel.html)??>
            ${item.panel.html?no_esc}
          <#elseif (item.panel.text)??>
            <p class="govuk-body">${item.panel.text}</p>
          </#if>
        </div>
      </#if>
    </#list>
  </div>
  
</#macro>

<#function govukTabs params>
  <#local result><@govukTabsMacro params=params/></#local>
  <#return result>
</#function>