<#macro govukHeaderMacro params>
  <#local menuButtonText=((params.menuButtonText)?has_content)?then((params.menuButtonText)!, "Menu")>
  
  <#local _stEdwardsCrown>
  <!--[if gt IE 8]><!-->
  <svg
    aria-hidden="true"
    focusable="false"
    class="govuk-header__logotype-crown"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 132 97"
    height="30"
    width="36"
  >
    <path
      fill="currentColor" fill-rule="evenodd"
      d="M25 30.2c3.5 1.5 7.7-.2 9.1-3.7 1.5-3.6-.2-7.8-3.9-9.2-3.6-1.4-7.6.3-9.1 3.9-1.4 3.5.3 7.5 3.9 9zM9 39.5c3.6 1.5 7.8-.2 9.2-3.7 1.5-3.6-.2-7.8-3.9-9.1-3.6-1.5-7.6.2-9.1 3.8-1.4 3.5.3 7.5 3.8 9zM4.4 57.2c3.5 1.5 7.7-.2 9.1-3.8 1.5-3.6-.2-7.7-3.9-9.1-3.5-1.5-7.6.3-9.1 3.8-1.4 3.5.3 7.6 3.9 9.1zm38.3-21.4c3.5 1.5 7.7-.2 9.1-3.8 1.5-3.6-.2-7.7-3.9-9.1-3.6-1.5-7.6.3-9.1 3.8-1.3 3.6.4 7.7 3.9 9.1zm64.4-5.6c-3.6 1.5-7.8-.2-9.1-3.7-1.5-3.6.2-7.8 3.8-9.2 3.6-1.4 7.7.3 9.2 3.9 1.3 3.5-.4 7.5-3.9 9zm15.9 9.3c-3.6 1.5-7.7-.2-9.1-3.7-1.5-3.6.2-7.8 3.7-9.1 3.6-1.5 7.7.2 9.2 3.8 1.5 3.5-.3 7.5-3.8 9zm4.7 17.7c-3.6 1.5-7.8-.2-9.2-3.8-1.5-3.6.2-7.7 3.9-9.1 3.6-1.5 7.7.3 9.2 3.8 1.3 3.5-.4 7.6-3.9 9.1zM89.3 35.8c-3.6 1.5-7.8-.2-9.2-3.8-1.4-3.6.2-7.7 3.9-9.1 3.6-1.5 7.7.3 9.2 3.8 1.4 3.6-.3 7.7-3.9 9.1zM69.7 17.7l8.9 4.7V9.3l-8.9 2.8c-.2-.3-.5-.6-.9-.9L72.4 0H59.6l3.5 11.2c-.3.3-.6.5-.9.9l-8.8-2.8v13.1l8.8-4.7c.3.3.6.7.9.9l-5 15.4v.1c-.2.8-.4 1.6-.4 2.4 0 4.1 3.1 7.5 7 8.1h.2c.3 0 .7.1 1 .1.4 0 .7 0 1-.1h.2c4-.6 7.1-4.1 7.1-8.1 0-.8-.1-1.7-.4-2.4V34l-5.1-15.4c.4-.2.7-.6 1-.9zM66 92.8c16.9 0 32.8 1.1 47.1 3.2 4-16.9 8.9-26.7 14-33.5l-9.6-3.4c1 4.9 1.1 7.2 0 10.2-1.5-1.4-3-4.3-4.2-8.7L108.6 76c2.8-2 5-3.2 7.5-3.3-4.4 9.4-10 11.9-13.6 11.2-4.3-.8-6.3-4.6-5.6-7.9 1-4.7 5.7-5.9 8-.5 4.3-8.7-3-11.4-7.6-8.8 7.1-7.2 7.9-13.5 2.1-21.1-8 6.1-8.1 12.3-4.5 20.8-4.7-5.4-12.1-2.5-9.5 6.2 3.4-5.2 7.9-2 7.2 3.1-.6 4.3-6.4 7.8-13.5 7.2-10.3-.9-10.9-8-11.2-13.8 2.5-.5 7.1 1.8 11 7.3L80.2 60c-4.1 4.4-8 5.3-12.3 5.4 1.4-4.4 8-11.6 8-11.6H55.5s6.4 7.2 7.9 11.6c-4.2-.1-8-1-12.3-5.4l1.4 16.4c3.9-5.5 8.5-7.7 10.9-7.3-.3 5.8-.9 12.8-11.1 13.8-7.2.6-12.9-2.9-13.5-7.2-.7-5 3.8-8.3 7.1-3.1 2.7-8.7-4.6-11.6-9.4-6.2 3.7-8.5 3.6-14.7-4.6-20.8-5.8 7.6-5 13.9 2.2 21.1-4.7-2.6-11.9.1-7.7 8.8 2.3-5.5 7.1-4.2 8.1.5.7 3.3-1.3 7.1-5.7 7.9-3.5.7-9-1.8-13.5-11.2 2.5.1 4.7 1.3 7.5 3.3l-4.7-15.4c-1.2 4.4-2.7 7.2-4.3 8.7-1.1-3-.9-5.3 0-10.2l-9.5 3.4c5 6.9 9.9 16.7 14 33.5 14.8-2.1 30.8-3.2 47.7-3.2z"></path>
  </svg>
  <!--<![endif]-->
  <!--[if IE 8]>
  <img src="${(params.assetsPath)!("/assets/images")}/govuk-logotype-crown.png" class="govuk-header__logotype-crown-fallback-image" width="36" height="32" alt="">
  <![endif]-->
  </#local>
  
  <#local _tudorCrown>
  <!--[if gt IE 8]><!-->
  <svg
    aria-hidden="true"
    focusable="false"
    class="govuk-header__logotype-crown"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 32 30"
    height="30"
    width="32"
  >
    <path
      fill="currentColor" fill-rule="evenodd"
      d="M22.6 10.4c-1 .4-2-.1-2.4-1-.4-.9.1-2 1-2.4.9-.4 2 .1 2.4 1s-.1 2-1 2.4m-5.9 6.7c-.9.4-2-.1-2.4-1-.4-.9.1-2 1-2.4.9-.4 2 .1 2.4 1s-.1 2-1 2.4m10.8-3.7c-1 .4-2-.1-2.4-1-.4-.9.1-2 1-2.4.9-.4 2 .1 2.4 1s0 2-1 2.4m3.3 4.8c-1 .4-2-.1-2.4-1-.4-.9.1-2 1-2.4.9-.4 2 .1 2.4 1s-.1 2-1 2.4M17 4.7l2.3 1.2V2.5l-2.3.7-.2-.2.9-3h-3.4l.9 3-.2.2c-.1.1-2.3-.7-2.3-.7v3.4L15 4.7c.1.1.1.2.2.2l-1.3 4c-.1.2-.1.4-.1.6 0 1.1.8 2 1.9 2.2h.7c1-.2 1.9-1.1 1.9-2.1 0-.2 0-.4-.1-.6l-1.3-4c-.1-.2 0-.2.1-.3m-7.6 5.7c.9.4 2-.1 2.4-1 .4-.9-.1-2-1-2.4-.9-.4-2 .1-2.4 1s0 2 1 2.4m-5 3c.9.4 2-.1 2.4-1 .4-.9-.1-2-1-2.4-.9-.4-2 .1-2.4 1s.1 2 1 2.4m-3.2 4.8c.9.4 2-.1 2.4-1 .4-.9-.1-2-1-2.4-.9-.4-2 .1-2.4 1s0 2 1 2.4m14.8 11c4.4 0 8.6.3 12.3.8 1.1-4.5 2.4-7 3.7-8.8l-2.5-.9c.2 1.3.3 1.9 0 2.7-.4-.4-.8-1.1-1.1-2.3l-1.2 4c.7-.5 1.3-.8 2-.9-1.1 2.5-2.6 3.1-3.5 3-1.1-.2-1.7-1.2-1.5-2.1.3-1.2 1.5-1.5 2.1-.1 1.1-2.3-.8-3-2-2.3 1.9-1.9 2.1-3.5.6-5.6-2.1 1.6-2.1 3.2-1.2 5.5-1.2-1.4-3.2-.6-2.5 1.6.9-1.4 2.1-.5 1.9.8-.2 1.1-1.7 2.1-3.5 1.9-2.7-.2-2.9-2.1-2.9-3.6.7-.1 1.9.5 2.9 1.9l.4-4.3c-1.1 1.1-2.1 1.4-3.2 1.4.4-1.2 2.1-3 2.1-3h-5.4s1.7 1.9 2.1 3c-1.1 0-2.1-.2-3.2-1.4l.4 4.3c1-1.4 2.2-2 2.9-1.9-.1 1.5-.2 3.4-2.9 3.6-1.9.2-3.4-.8-3.5-1.9-.2-1.3 1-2.2 1.9-.8.7-2.3-1.2-3-2.5-1.6.9-2.2.9-3.9-1.2-5.5-1.5 2-1.3 3.7.6 5.6-1.2-.7-3.1 0-2 2.3.6-1.4 1.8-1.1 2.1.1.2.9-.3 1.9-1.5 2.1-.9.2-2.4-.5-3.5-3 .6 0 1.2.3 2 .9l-1.2-4c-.3 1.1-.7 1.9-1.1 2.3-.3-.8-.2-1.4 0-2.7l-2.9.9C1.3 23 2.6 25.5 3.7 30c3.7-.5 7.9-.8 12.3-.8"></path>
  </svg>
  <!--<![endif]-->
  <!--[if IE 8]>
  <img src="${(params.assetsPath)!("/assets/images")}/govuk-logotype-tudor-crown.png" class="govuk-header__logotype-crown-fallback-image" width="32" height="30" alt="">
  <![endif]-->
  </#local>
  
  <header class="govuk-header ${((params.classes)?has_content)?then((params.classes)!, "")}" role="banner" data-module="govuk-header"<#list params.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>
    <div class="govuk-header__container ${(params.containerClasses)!("govuk-width-container")}">
      <div class="govuk-header__logo">
        <a href="${(params.homepageUrl)!("/")}" class="govuk-header__link govuk-header__link--homepage">
          <span class="govuk-header__logotype">
            ${(((params.useTudorCrown)?? && params.useTudorCrown)?then(_tudorCrown, _stEdwardsCrown))?no_esc}
            <span class="govuk-header__logotype-text">
              GOV.UK
            </span>
          </span>
          <#if ((params.productName)?has_content)>
          <span class="govuk-header__product-name">
            ${(params.productName)!}
          </span>
          </#if>
        </a>
      </div>
      <#if (params.serviceName)?has_content || (params.navigation)??>
      <div class="govuk-header__content">
      <#if (params.serviceName)?has_content>
      <#if (params.serviceUrl)?has_content>
        <a href="${(params.serviceUrl)!}" class="govuk-header__link govuk-header__service-name">
          ${(params.serviceName)!}
        </a>
      <#else>
        <span class="govuk-header__service-name">
          ${(params.serviceName)!}
        </span>
      </#if>
      </#if>
      <#if (params.navigation)??>
      <nav aria-label="${(params.navigationLabel)!(menuButtonText)}" class="govuk-header__navigation ${((params.navigationClasses)?has_content)?then((params.navigationClasses)!, "")}">
        <button type="button" class="govuk-header__menu-button govuk-js-header-toggle" aria-controls="navigation" aria-label="${(params.menuButtonLabel)!("Show or hide menu")}" hidden>${(menuButtonText)!}</button>
  
        <ul id="navigation" class="govuk-header__navigation-list">
          <#list params.navigation![] as item>
            <#if (item.text)?has_content || (item.html)?has_content>
              <li class="govuk-header__navigation-item${((item.active)?? && item.active)?then(" govuk-header__navigation-item--active", "")}">
                <#if (item.href)?has_content>
                  <a class="govuk-header__link" href="${(item.href)!}"<#list item.attributes!{} as attribute, value> ${attribute}="${((value)!{})}"</#list>>
                </#if>
                  ${((item.html)?has_content)?then(item.html?no_esc, (item.text)!)}
                <#if (item.href)?has_content>
                  </a>
                </#if>
              </li>
            </#if>
          </#list>
        </ul>
      </nav>
      </#if>
      </div>
      </#if>
    </div>
  </header>
  
</#macro>

<#function govukHeader params>
  <#local result><@govukHeaderMacro params=params/></#local>
  <#return result>
</#function>