<#macro _taskListItemMacro params item index freeVars><#local caller><#nested/></#local><#if freeVars.idPrefix??><#local idPrefix=freeVars.idPrefix></#if><#local hintId=idPrefix + "-" + index + "-hint"><#local statusId=idPrefix + "-" + index + "-status">   <li class="govuk-task-list__item<#if (item.href)?has_content> govuk-task-list__item--with-link</#if><#if (item.classes)?has_content> ${(item.classes)!}</#if>">     <div class="govuk-task-list__name-and-hint">     <#if (item.href)?has_content>       <a class="govuk-link govuk-task-list__link<#if (item.title.classes)?has_content> ${(item.title.classes)!}</#if>" href="${(item.href)!}" aria-describedby="${((item.hint)??)?then(hintId + " ", "")}${(statusId)!}">         ${((item.title.html)?has_content)?then(item.title.html?no_esc?markup_string?trim?no_esc, (item.title.text)!)}       </a>     <#else>       <div<#if (item.title.classes)?has_content> class="${(item.title.classes)!}"</#if>>         ${((item.title.html)?has_content)?then(item.title.html?no_esc?markup_string?trim?no_esc, (item.title.text)!)}       </div>     </#if>     <#if (item.hint)??>       <div id="${(hintId)!}" class="govuk-task-list__hint">         ${((item.hint.html)?has_content)?then(item.hint.html?no_esc?markup_string?trim?no_esc, (item.hint.text)!)}       </div>     </#if>     </div>     <div class="govuk-task-list__status<#if (item.status.classes)?has_content> ${(item.status.classes)!}</#if>" id="${(statusId)!}">     <#if (item.status.tag)??>       ${tag.govukTag(((item.status.tag)!{}))?markup_string?trim?no_esc}     <#else>       ${((item.status.html)?has_content)?then(item.status.html?no_esc?markup_string?trim?no_esc, (item.status.text)!)}     </#if>     </div>   </li></#macro>
<#function _taskListItem params item index freeVars>
  <#local result><@_taskListItemMacro params=params item=item index=index freeVars=freeVars/></#local>
  <#return result>
</#function>

<#macro govukTaskListMacro params>
  <#import "../macros/attributes.ftlh" as attributes>
  <#import "./tag.ftlh" as tag><#local idPrefix=((params.idPrefix)?has_content)?then((params.idPrefix)!, "task-list")>
  
  <ul class="govuk-task-list<#if (params.classes)?has_content> ${(params.classes)!}</#if>"${attributes.govukAttributes(((params.attributes)!{}))}>
    <#list params.items as item>${((item)??)?then(_taskListItem(params, item, item?counter, ((idPrefix)??)?then({ "idPrefix": idPrefix }, {})), "")}
    </#list>
  </ul>
  
</#macro>

<#function govukTaskList params>
  <#local result><@govukTaskListMacro params=params/></#local>
  <#return result>
</#function>