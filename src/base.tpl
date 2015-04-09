<!doctype html>
<!--[if lt IE 7]> <html class="lt-ie9 lt-ie8 lt-ie7" lang="en" dir="ltr"> <![endif]-->
<!--[if IE 7]>    <html class="lt-ie9 lt-ie8" lang="en" dir="ltr"> <![endif]-->
<!--[if IE 8]>    <html class="lt-ie9" lang="en" dir="ltr"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en" dir="ltr" itemscope itemtype="http://schema.org/Product"> <!--<![endif]-->
<head>

<title>
    Introducing Charms | Documentation
 | Juju</title>

<meta charset="UTF-8" />
<meta name="description" content="Learn how to install, configure, bootstrap Juju and how to create a charm through the Juju documentation" />
<meta name="keywords" content="juju, charms, services, service orchestration, cloud, deployment, puppet, chef, fuel, cloud tools, service management, cloud management, configuration management, linux tool, openstack tool, ubuntu, cloud design, cloud orchestration" />


<meta name="author" content="Canonical" />
<meta name="viewport" content="width=device-width, initial-scale=1" />

<!--[if IE]>
<meta http-equiv="X-UA-Compatible" content="IE=8">
<![endif]-->

<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon" />

<!-- google fonts -->
<link href='https://fonts.googleapis.com/css?family=Ubuntu:400,300,300italic,400italic,700,700italic%7CUbuntu+Mono' rel='stylesheet' type='text/css' />

<!-- stylesheets -->
<link rel="stylesheet" type="text/css" media="screen" href="//assets.ubuntu.com/sites/guidelines/css/responsive/latest/ubuntu-styles.css" />
<link rel="stylesheet" type="text/css" media="screen" href="../css/main.css" />

<!-- load basic yui, our modules file, the loader and sub to set up modules with
combo load -->
<script type="text/javascript"
    
    src="/prod/combo?yui/yui/yui-min.js&amp;app/modules-min.js&amp;yui/loader/loader-min.js&amp;yui/substitute/substitute-min.js&amp;plugins/respond.min.js&amp;plugins/modernizr.2.7.1.js&amp;plugins/handlebars.runtime-v2.0.0.js&amp;templates/templates.js">
    
</script>

<script type="text/javascript">
      YUI.GlobalConfig = {
          combine: true,
          base: '/prod/combo?yui/',
          comboBase: '/prod/combo?',
          maxURLLength: 1300,
          root: 'yui/',
            groups: {
              app: {
                  combine: true,
                  base: '/prod/combo?app',
                  comboBase: '/prod/combo?',
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
    window.csUrl = "https://api.jujucharms.com/charmstore/v4";
</script>


<meta name="twitter:card" content="summary">
<meta name="twitter:site" content="@ubuntucloud">
<meta name="twitter:creator" content="@ubuntucloud">
<meta name="twitter:domain" content="jujucharms.com">
<meta name="twitter:title" content="Documentation - Juju">
<meta name="twitter:description" content="Learn about the using Juju through the Juju GUI or CLI and see how it makes creating, configuring, deploying and managing services in the cloud simple.">
<meta name="twitter:image" content="http://jujucharms.com/static/img/juju-twitter.png">


</head>

<body class="

"
>

<header class="banner global" role="banner">

    
        <nav role="navigation" class="nav-primary nav-right">
    <div class="logo">
        <a class="logo-ubuntu" href="/">
            <img width="139" height="19" src="/static/img/logos/juju-logo.png" alt="Juju logo for print" />
        </a>
    </div>

    

    <ul>
        <li class="accessibility-aid">
            <a accesskey="s" href="#main-content">Jump to content</a>
        </li>

        <li>
    <a
        class=""
        href="/solutions"
    >
       Solutions
    </a>
    </li>
        <li><a href="https://demo.jujucharms.com" target="_blank" class="external">Demo</a></li>
        <li>
    <a
        class=""
        href="/about"
    >
       About
    </a>
    </li>
        <li>
    <a
        class=""
        href="/about/features"
    >
       Features
    </a>
    </li>
        <li>
    <a
        class=""
        href="/community"
    >
       Community
    </a>
    </li>
        <li>
    <a
        class="active"
        href="/docs/"
    >
       Docs
    </a>
    </li>
        <li>
    <a
        class=""
        href="/get-started"
    >
       Get started
    </a>
    </li>
        <li class="user-dropdown"><span id="user-dropdown"></span></li>
    </ul>
    <a href="#canonlist" class="nav-toggle no-script">*</a>
</nav>
    

</header>



<div class="contextual-bar">
    
        <form class="search-form" action="/q" method="GET">
    <input
        type="search" name="text"
        class="form-text" placeholder="Search for solutions"
        value=""
    />
    <button type="submit">
        <img
            src="/static/img/shared/search-icon.svg"
            alt="Search" height="28"
        />
    </button>
    
</form>
    
</div>

<div class="wrapper">
<div id="main-content">





    
<div class="row jujudocs">
    <div class="inner-wrapper">
        <div class="four-col box jujudocs-nav">
            <form action="/docs/search/" method="GET" class="search-form">
                <input type="text" name="text" placeholder="Search docs" />
                <button type="submit">
                    <img src="/static/img/shared/search-icon.svg"
                        alt="Search" height="28" />
                </button>
            </form>
            <div class="twelve-col">
              $DOCNAV
            </div>
        </div>
        <div class="eight-col last-col">
            <div class="jujudocs-content">

                $CONTENT


              </div>
        </div>
    </div>
</div>



</div><!-- /.inner-wrapper -->

</div><!-- /.wrapper -->


<div class="footer-wrapper strip-light">
<div class="solutions-cta">
    <a href="/solutions">Browse all solutions&nbsp;&rsaquo;</a>
</div>
<footer class="global clearfix">
    <p class="top-link">
        <a href="#">Back to the top</a>
    </p>
    <nav role="navigation" class="inner-wrapper">
        <div class="row">
            <div class="seven-col">
                <ul class="no-bullets">
                    <li><a class="external" href="https://demo.jujucharms.com">Demo</a></li>
                    <li><a href="/about">About</a></li>
                    <li><a href="/about/features">Features</a></li>
                    <li><a href="/docs">Docs</a></li>
                    <li><a href="/get-started">Get Started</a></li>
                </ul>
            </div>
            <div class="five-col last-col">
                <ul class="social--right">
                    <li class="social__item">
                        <a href="https://plus.google.com/103184405956510785630/posts" class="social__google"><span class="accessibility-aid">Juju on Google+</span></a>
                    </li>
                    <li class="social__item">
                        <a href="http://www.twitter.com/ubuntucloud" class="social__twitter"><span class="accessibility-aid">Ubuntu Cloud on Twitter</span></a>
                    </li>
                    <li class="social__item">
                        <a href="http://www.facebook.com/ubuntucloud" class="social__facebook"><span class="accessibility-aid">Ubuntu Cloud on Facebook</span></a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="legal clearfix">
        <div class="legal-inner">
            <p class="twelve-col">
                &copy; 2014 Canonical Ltd. Ubuntu and Canonical are registered trademarks of Canonical Ltd.
            </p>
            <ul class="inline bullets clear">
                <li><a href="http://www.ubuntu.com/legal">Legal information</a></li>
                <li><a href="https://github.com/CanonicalLtd/jujucharms.com/issues">Report a bug on this site</a></li>
            </ul>
            <span class="accessibility-aid">
                <a href="#">Got to the top of the page</a>
            </span>
        </div>
    </div>
</footer>
</div>
