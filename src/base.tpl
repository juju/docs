<!DOCTYPE html>
<!-- saved from url=(0050)https://jujucharms.com/docs/stable/getting-started -->
<html class=" yui3-js-enabled js flexbox flexboxlegacy canvas canvastext webgl no-touch geolocation postmessage websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers applicationcache svg inlinesvg smil svgclippaths" lang="en" dir="ltr" itemscope="" itemtype="http://schema.org/Product" style=""><div id="yui3-css-stamp" style="position: absolute !important; visibility: hidden !important"></div><!--<![endif]--><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>
%%TITLE%%
</title>


<meta name="description" content="Learn how to install, configure, bootstrap Juju and how to create a charm through the Juju documentation">
<meta name="keywords" content="juju, charms, services, cloud, deployment, puppet, chef, fuel, cloud tools, service management, cloud management, configuration management, linux tool, openstack tool, ubuntu, cloud design, applications, model, modelling, cloud orchestration, service orchestration">


<meta name="author" content="Canonical">
<meta name="viewport" content="width=device-width, initial-scale=1">

<!--[if IE]>
<meta http-equiv="X-UA-Compatible" content="IE=8">
<![endif]-->

<link rel="shortcut icon" href="https://jujucharms.com/static/img/favicon.ico" type="image/x-icon">

<link rel="apple-touch-icon-precomposed" sizes="57x57" href="https://jujucharms.com/static/img/icons/apple-touch-icon-57x57-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="60x60" href="https://jujucharms.com/static/img/icons/apple-touch-icon-60x60-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="https://jujucharms.com/static/img/icons/apple-touch-icon-72x72-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="76x76" href="https://jujucharms.com/static/img/icons/apple-touch-icon-76x76-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="https://jujucharms.com/static/img/icons/apple-touch-icon-114x114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="120x120" href="https://jujucharms.com/static/img/icons/apple-touch-icon-120x120-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="https://jujucharms.com/static/img/icons/apple-touch-icon-144x144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="152x152" href="https://jujucharms.com/static/img/icons/apple-touch-icon-152x152-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="180x180" href="https://jujucharms.com/static/img/icons/apple-touch-icon-180x180-precomposed.png">
<link rel="apple-touch-icon-precomposed" href="https://jujucharms.com/static/img/icons/apple-touch-icon-precomposed.png">


<!-- google fonts -->
<link href="../_static/css" rel="stylesheet" type="text/css">

<!-- stylesheets -->
<link rel="stylesheet" type="text/css" media="screen" href="../_static/build.css">

<!-- load basic yui, our modules file, the loader and sub to set up modules with
combo load -->
<script type="text/javascript" async="" src="../_static/munchkin.js"></script><script src="../_static/8875.js" async="" type="text/javascript"></script><script type="text/javascript" async="" src="../_static/heap-3280028620.js"></script><script type="text/javascript" async="" src="../_static/analytics.js"></script><script async="" src="../_static/gtm.js"></script><script type="text/javascript" src="../_static/sfcombo">
    
</script>

<script type="text/javascript">
      YUI.GlobalConfig = {
          combine: true,
          base: '/prod/sfcombo?yui/',
          comboBase: '/prod/sfcombo?',
          maxURLLength: 1300,
          root: 'yui/',
            groups: {
              app: {
                  combine: true,
                  base: '/prod/sfcombo?app',
                  comboBase: '/prod/sfcombo?',
                  root: 'app/',
                  
                  filter: 'min',
                  
                  // From modules.js
                  modules: YUI_MODULES,
              }
          },
          static_root:'/static/'
    };
 </script>

<!-- provide charmstore url -->
<script type="text/javascript">
    window.csUrl = "https://api.jujucharms.com/charmstore/v5";
</script>


<meta name="twitter:card" content="summary">
<meta name="twitter:site" content="@ubuntucloud">
<meta name="twitter:creator" content="@ubuntucloud">
<meta name="twitter:domain" content="jujucharms.com">
<meta name="twitter:title" content="Documentation - Juju">
<meta name="twitter:description" content="Learn about the using Juju through the Juju GUI or CLI and see how it makes creating, configuring, deploying and operating software in the cloud simple.">
<meta name="twitter:image" content="https://jujucharms.com/static/img/juju-twitter.png">


<script charset="utf-8" id="yui_3_17_1_1_1490188284910_2" src="../_static/sfcombo(1)" async=""></script><script type="text/javascript" async="" src="../_static/munchkin(1).js"></script><script charset="utf-8" id="yui_3_17_1_3_1490188284910_2" src="../_static/sfcombo(2)" async=""></script></head>

<body class="
">


<header class="banner global" role="banner">

    <nav role="navigation" class="nav-primary nav-right nav-gui-active" id="nav">
    
    <span class="accessibility-aid">
        <a accesskey="s" href="https://jujucharms.com/docs/stable/getting-started#main-content">Jump to content</a>
    </span>

    <div class="logo">
        <a href="https://jujucharms.com/">
            <svg xmlns="http://www.w3.org/2000/svg" width="78" height="32" viewBox="309.33 322.034 571.89 206.329"><circle fill="#E95420" cx="408.542" cy="421.246" r="99.212"></circle><g fill="#FFF"><circle cx="414.212" cy="415.576" r="6.142"></circle><path d="M419.88 404.237h-11.337v-45.354c0-10.94 8.902-19.842 19.842-19.842s19.842 8.903 19.842 19.843v11.34l-11.338-.002v-11.337c0-2.272-.886-4.408-2.49-6.014-1.607-1.605-3.742-2.492-6.015-2.492-4.688 0-8.504 3.816-8.504 8.505v45.354z"></path><path d="M456.73 424.08c-10.94 0-19.843-8.9-19.843-19.842v-28.345h11.34v28.345c0 4.69 3.813 8.505 8.503 8.505 4.688 0 8.503-3.814 8.503-8.505v-28.345h11.34v28.345c0 5.3-2.065 10.282-5.813 14.03-3.745 3.75-8.728 5.812-14.03 5.812z"></path><circle cx="357.52" cy="483.605" r="6.143"></circle><path d="M363.188 472.27H351.85v-62.362c0-10.94 8.9-19.842 19.844-19.842 10.94 0 19.842 8.9 19.842 19.842v11.34h-11.34v-11.34c0-2.272-.883-4.408-2.49-6.014-1.606-1.604-3.742-2.49-6.013-2.49-4.69 0-8.505 3.814-8.505 8.504v62.36z"></path><path d="M400.04 475.103c-10.942 0-19.844-8.9-19.844-19.844v-28.347h11.34v28.348c0 4.69 3.813 8.503 8.503 8.503s8.503-3.814 8.503-8.504v-28.347h11.338v28.348c0 5.298-2.062 10.28-5.81 14.03-3.75 3.75-8.732 5.813-14.03 5.813z"></path></g><g><path d="M620.714 446.453c0 6.744-.678 12.98-2.02 18.707-1.353 5.73-3.68 10.72-6.98 14.967-3.307 4.246-7.686 7.553-13.146 9.908-5.46 2.357-12.306 3.54-20.528 3.54-4.854 0-9.304-.438-13.35-1.313-4.042-.88-7.617-1.922-10.718-3.135-3.104-1.215-5.697-2.494-7.787-3.842-2.092-1.35-3.675-2.562-4.753-3.643l6.473-11.123c1.214 1.08 2.73 2.26 4.55 3.538 1.82 1.283 3.945 2.46 6.372 3.54 2.426 1.08 5.122 1.954 8.09 2.628 2.964.676 6.2 1.012 9.708 1.012 10.38 0 18.03-2.73 22.955-8.19 4.92-5.46 7.38-14.796 7.38-28.01v-94.653h13.755v96.068zM729.255 486.902c-3.91 1.08-9.17 2.293-15.773 3.64-6.607 1.347-14.697 2.02-24.27 2.02-7.822 0-14.36-1.144-19.62-3.437-5.257-2.29-9.503-5.525-12.74-9.707-3.235-4.178-5.56-9.234-6.978-15.17-1.416-5.93-2.123-12.47-2.123-19.615V385.98h13.146v54.402c0 7.418.54 13.69 1.62 18.81 1.077 5.128 2.83 9.272 5.257 12.44 2.43 3.17 5.562 5.46 9.404 6.874 3.844 1.418 8.527 2.125 14.057 2.125 6.2 0 11.594-.335 16.18-1.01 4.584-.673 7.482-1.28 8.697-1.82v-91.82h13.147v100.922h-.002zM739.185 528.363c-1.482 0-3.338-.203-5.562-.607-2.227-.404-3.873-.88-4.955-1.416l1.82-10.72c.945.27 2.225.538 3.842.81 1.62.27 3.17.404 4.652.404 7.953 0 13.246-2.225 15.875-6.674 2.63-4.45 3.945-11.125 3.945-20.023V385.98h13.146v103.55c0 13.214-2.498 22.985-7.484 29.325-4.99 6.336-13.418 9.508-25.28 9.508zM881.22 486.902c-3.912 1.08-9.17 2.293-15.773 3.64-6.607 1.347-14.697 2.02-24.27 2.02-7.822 0-14.36-1.144-19.62-3.437-5.257-2.29-9.505-5.525-12.74-9.707-3.235-4.178-5.56-9.234-6.978-15.17-1.417-5.93-2.124-12.47-2.124-19.615V385.98h13.146v54.402c0 7.418.533 13.69 1.615 18.81 1.078 5.128 2.832 9.272 5.26 12.44 2.428 3.17 5.56 5.46 9.402 6.874 3.845 1.418 8.526 2.125 14.058 2.125 6.197 0 11.594-.335 16.18-1.01 4.584-.673 7.482-1.28 8.697-1.82v-91.82h13.145v100.922z" class="logo__text"></path></g></svg>
        </a>
    </div>

    <ul>
        <li>
        <a class="" href="https://jujucharms.com/store">
            Store
        </a>
    </li>
        <li>
        <a class="" href="https://jujucharms.com/how-it-works">
            How it works
        </a>
    </li>
        <li>
        <a class="" href="https://jujucharms.com/community">
            Community
        </a>
    </li>
        <li>
        <a class="active" href="https://jujucharms.com/docs/">
            Docs
        </a>
    </li>
        
          <li><a class="try-beta" href="https://jujucharms.com/new" rel="nofollow">Try the beta</a></li>
        
    </ul>

    <div class="nav-toggle">
        <a href="https://jujucharms.com/docs/stable/getting-started#nav" class="nav-toggle__link open">
            <svg class="nav-toggle__image" xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 30 30">
              <path fill="#888" d="M5 10h20v2H6zM5 16h20v2H6zM5 22h20v2H6z"></path>
            </svg>
        </a>
        <a href="https://jujucharms.com/docs/stable/getting-started#" class="nav-toggle__link close">
            <svg class="nav-toggle__image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16">
                <g color="#000" fill="none">
                    <path d="M2.538 2.63l16 16M16 2.63L2.538 16" stroke="#888" stroke-width="2" stroke-linejoin="round"></path>
                </g>
            </svg>
        </a>
    </div>

    <ul class="user-nav">
      <li>
            
            <a href="https://jujucharms.com/login/" class="inactive menu-link js-menu-login">
                Sign in
            </a>
            
        </li>
    </ul>
</nav>
    <div class="search-container">
    <form class="search-form" action="https://jujucharms.com/q" method="GET" id="yui_3_17_1_1_1490188284910_20">
        <input type="search" name="text" class="form-text" placeholder="Search the store" value="">
        <button type="submit">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" class="search-icon__image">
                <g transform="matrix(.667 0 0 .667 -74.667 -285.575)">
                    <path d="M129.93 444.03l-2.27 2.275 6.07 6.07L136 450.1z" fill="#878787"></path>
                    <ellipse ry="9.479" rx="9.479" cy="438.862" cx="122.5" fill="none" stroke="#878787" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></ellipse>
                </g>
            </svg>
        </button>
        <a href="https://jujucharms.com/docs/stable/getting-started" class="search-close">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" class="search-close__image">
                <g color="#000" fill="none">
                    <path d="M2.538 2.63l11.006 11.006M13.544 2.63L2.538 13.637" overflow="visible" stroke="#878787" stroke-width="2"></path>
                </g>
            </svg>
        </a>
    </form>
</div>

<div class="search-panel">
    <div class="row">
        <div class="inner-wrapper">
            <div class="two-col no-margin-bottom">
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/canonical-kubernetes" class="search-panel__featured-link">
                        <img src="../_static/icon.svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">kubernetes</p>
                    </a>
                </div>
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/elasticsearch" class="search-panel__featured-link">
                        <img src="../_static/icon(1).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">elasticsearch</p>
                    </a>
                </div>
            </div>
            <div class="two-col no-margin-bottom">
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/u/asanjar/hdp-tez" class="search-panel__featured-link">
                        <img src="../_static/icon(2).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">hdp-tez</p>
                    </a>
                </div>
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/hdp-storm" class="search-panel__featured-link">
                        <img src="../_static/icon(3).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">hdp-storm</p>
                    </a>
                </div>
            </div>
            <div class="two-col no-margin-bottom">
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/ceph" class="search-panel__featured-link">
                        <img src="../_static/icon(4).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">ceph</p>
                    </a>
                </div>
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/cassandra" class="search-panel__featured-link">
                        <img src="../_static/icon(5).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">cassandra</p>
                    </a>
                </div>
            </div>
            <div class="two-col no-margin-bottom">
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/percona-cluster" class="search-panel__featured-link">
                        <img src="../_static/icon(6).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">percona-cluster</p>
                    </a>
                </div>
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/glance" class="search-panel__featured-link">
                        <img src="../_static/icon(7).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">glance</p>
                    </a>
                </div>
            </div>
            <div class="two-col no-margin-bottom">
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/mariadb" class="search-panel__featured-link">
                        <img src="../_static/icon(8).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">mariadb</p>
                    </a>
                </div>
                <div class="two-col align-center search-panel__featured-charm">
                    <a href="https://jujucharms.com/spark" class="search-panel__featured-link">
                        <img src="../_static/icon(9).svg" alt="" class="search-panel__featured-image">
                        <p class="search-panel__featured-name">spark</p>
                    </a>
                </div>
            </div>
            <div class="two-col last-col no-margin-bottom">
                <h3 class="search-panel__heading">Popular searches</h3>
                <ul class="search-panel__list no-bullets">
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/openstack">openstack</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/ceph">ceph</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/mysql">mysql</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/hdp">hdp</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/spark">spark</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/nginx">nginx</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/redis">redis</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/jenkins">jenkins</a></li>
                    <li class="search-panel__list-item"><a href="https://jujucharms.com/q/logstash">logstash</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row row-footer">
        <div class="inner-wrapper">
            <div class="twelve-col last-col no-margin-bottom">
                <ul class="no-bullets inline-list">
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=openstack">openstack
                            <span class="search-panel__item-count">(108)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=applications">applications
                            <span class="search-panel__item-count">(248)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=databases">databases
                            <span class="search-panel__item-count">(71)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=app-servers">app-servers
                            <span class="search-panel__item-count">(75)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=file-servers">file-servers
                            <span class="search-panel__item-count">(48)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=monitoring">monitoring
                            <span class="search-panel__item-count">(28)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=misc">misc
                            <span class="search-panel__item-count">(279)</span>
                        </a>
                    </li>
                    <li class="search-panel__list-item inline-list__item">
                        <a href="https://jujucharms.com/q/?tags=ops">ops
                            <span class="search-panel__item-count">(22)</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

</header>

<div class="wrapper">
<div id="main-content">

    <div class="login-notification">
        If requested, in the address bar above, please allow popups.
    </div>






    



<div class="row jujudocs">
    <nav class="jujudocs__nav">
        <form action="https://jujucharms.com/docs/search/" method="GET" class="search-form">
            <input type="text" name="text" placeholder="Search docs">
            <input type="hidden" name="version" value="2.1">
            <button type="submit">
                Search
            </button>
        </form>
        <div class="versions-nav">
            
            <strong class="label">Versions:</strong>
            <ul>
                
                
                
                <li><a href="#">Versions go here</a></li>
                
                
            </ul>
            <a class="stable" href="https://jujucharms.com/docs/stable/getting-started">stable</a>
            
        </div>
        <div class="jujudocs-menu">

                      %%DOCNAV%%
        
        </div>
    </nav>
    <main class="jujudocs__content">

                   %%CONTENT%%
    
    </main>
    <aside class="jujudocs__toc">
    </aside>
</div>



</div><!-- /.inner-wrapper -->

</div><!-- /.wrapper -->


<div class="footer-wrapper strip-white">
<footer class="global clearfix">
    <p class="top-link">
        <a href="https://jujucharms.com/docs/stable/getting-started#">Back to the top</a>
    </p>
    <nav role="navigation" class="inner-wrapper">
        <div class="row">
            <div class="seven-col">
                <ul class="no-bullets seven-col">
                    <li><a href="https://jujucharms.com/docs">Docs</a></li>
                    <li><a href="https://jujucharms.com/community">Community</a></li>
                    <li><a href="https://jujucharms.com/community/blog">Blog</a></li>
                    <li><a href="https://jujucharms.com/docs">Install Juju</a></li>
                </ul>
                <div class="legal">
                    <p>© 2017 Canonical Ltd. Ubuntu and Canonical are registered trademarks of Canonical Ltd.</p>
                    <ul class="inline-list clear bullets">
                        <li class="inline-list__item"><a href="http://www.ubuntu.com/legal"><small>Legal information</small></a></li>
                        <li class="inline-list__item"><a href="https://github.com/CanonicalLtd/jujucharms.com/issues"><small>Report a bug on this site</small></a></li>
                    </ul>
                    <span class="accessibility-aid">
                        <a href="https://jujucharms.com/docs/stable/getting-started#">Got to the top of the page</a>
                    </span>
                </div>
            </div>
            <div class="five-col last-col">
                <ul class="social-list right">
                    <li class="social-list__item">
                        <a href="http://youtube.com/jujucharms" class="social-list__item--youtube"><svg width="31" height="31" viewBox="0 0 31 31" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><path d="M15.515.47c-3.99 0-7.817 1.585-10.638 4.407C2.055 7.697.47 11.525.47 15.515s1.585 7.817 4.407 10.64c2.82 2.82 6.648 4.405 10.638 4.405s7.817-1.585 10.64-4.406c2.82-2.822 4.405-6.65 4.405-10.64S28.975 7.7 26.154 4.878C23.332 2.055 19.504.47 15.514.47z" fill="#AEA79F" class="the-icon"></path><path d="M15.51 8.73s-4.05 0-6.75.195c-.376.045-1.198.05-1.932.817-.58.586-.767 1.916-.767 1.916s-.192 1.56-.192 3.122v1.464c0 1.56.193 3.123.193 3.123s.19 1.33.768 1.915c.733.768 1.698.744 2.127.824 1.544.148 6.56.194 6.56.194s4.055-.006 6.755-.2c.377-.046 1.2-.05 1.933-.818.578-.586.767-1.915.767-1.915s.192-1.562.192-3.123V14.78c0-1.56-.192-3.122-.192-3.122s-.19-1.33-.767-1.916c-.734-.768-1.556-.772-1.933-.817-2.7-.195-6.75-.195-6.75-.195h-.01zm-1.988 3.866l5.214 2.72-5.213 2.702v-5.422z" fill="#FFF"></path></g></svg> Juju on Youtube</a>
                    </li>
                    <li class="social-list__item">
                        <a href="https://plus.google.com/106305712267007929608/posts" class="social-list__item--google-plus">Juju on Google+</a>
                    </li>
                    <li class="social-list__item">
                        <a href="http://www.twitter.com/ubuntucloud" class="social-list__item--twitter">Ubuntu Cloud on Twitter</a>
                    </li>
                    <li class="social-list__item">
                        <a href="http://www.facebook.com/ubuntucloud" class="social-list__item--facebook">Ubuntu Cloud on Facebook</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</footer>
</div>

<script>
    var isOperaMini = (navigator.userAgent.indexOf('Opera Mini') > -1);
    if(isOperaMini) {
        var root = document.documentElement;
        root.className += " opera-mini";
    }
</script>

<script>
YUI().use('storefront-cookie', 'storefront-utils',
          function (Y) {
    Y.on('domready', function() {
        var inSession = false;
        var cookie = new Y.storefront.CookiePolicy();
        var utils = Y.storefront.utils;

        var notification = Y.one('.login-notification');
        var loginLink = Y.one('.js-menu-login');

        if (loginLink && notification) {
          loginLink.on('mouseenter', function () {
            notification.addClass('is-shown');
          });
          loginLink.on('mouseleave', function () {
            notification.removeClass('is-shown');
          });
        }

        cookie.render();
        utils.svgFallback(Y.one('#main-content'));
        utils.setupSearch();
    });
});
</script>


<script type="text/template" id="cookie-warning-template">
    <div class="cookie-policy">
        <div class="inner-wrapper">
            <a href="?cp=close" class="link-cta">Close</a>
            <p>We use cookies to improve your experience. By your continued use of this site you accept such use. To change your settings please <a href="http://www.ubuntu.com/legal/terms-and-policies/privacy-policy#cookies">see our policy</a>.</p>
        </div>
    </div>
</script>


<script>
YUI().use('storefront-docs-menu', 'storefront-utils', function(Y) {
    // Y.storefront.docsMenu.setup('.jujudocs-menu', 'ul > .section', 'getting-started');
    Y.storefront.utils.detailsFallback();
});

</script>


<script type="application/javascript">
  YUI().use('node', 'storefront-navigation', function (Y) {
    Y.storefront.mobileMenu();
  });
</script>

<!-- {version: ['1.0.4', '']} -->



<script type="text/javascript" id="">(function(){function b(){!1===c&&(c=!0,Munchkin.init("066-EOV-335"))}var c=!1,a=document.createElement("script");a.type="text/javascript";a.async=!0;a.src="//munchkin.marketo.net/munchkin.js";a.onreadystatechange=function(){"complete"!=this.readyState&&"loaded"!=this.readyState||b()};a.onload=b;document.getElementsByTagName("head")[0].appendChild(a)})();</script>

<script type="text/javascript" id="">setTimeout(function(){var a=document.createElement("script"),b=document.getElementsByTagName("script")[0];a.src=document.location.protocol+"//script.crazyegg.com/pages/scripts/0011/8875.js?"+Math.floor((new Date).getTime()/36E5);a.async=!0;a.type="text/javascript";b.parentNode.insertBefore(a,b)},1);</script>

<script type="text/javascript" id="">window.heap=window.heap||[];
heap.load=function(e,d){window.heap.appid=e;window.heap.config=d=d||{};var a=d.forceSSL||"https:"===document.location.protocol,b=document.createElement("script");b.type="text/javascript";b.async=!0;b.src=(a?"https:":"http:")+"//cdn.heapanalytics.com/js/heap-"+e+".js";a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(b,a);for(var b=function(a){return function(){heap.push([a].concat(Array.prototype.slice.call(arguments,0)))}},a=["clearEventProperties","identify","setEventProperties",
"track","unsetEventProperty"],c=0;c<a.length;c++)heap[a[c]]=b(a[c])};heap.load("3280028620");</script>
</body></html>
