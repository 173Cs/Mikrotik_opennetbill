<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>{Lang::T('Register')} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="icon" type="image/x-icon" href="{$config.favicon}">
    <link rel="stylesheet" type="text/css" href="system/plugin/captive_portal/css/font-awesome.css">
    <link rel="stylesheet" type="text/css" href="system/plugin/captive_portal/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="system/plugin/captive_portal/css/style.css">
    <link rel="stylesheet" type="text/css" href="system/plugin/captive_portal/css/sweetalert2.min.css">
    <script src="system/plugin/captive_portal/js/popper.min.js"></script>
    <script src="system/plugin/captive_portal/js/jquery.slim.min.js"></script>
    <script src="system/plugin/captive_portal/js/bootstrap.bundle.js"></script>
    <script type="text/javascript" src="system/plugin/captive_portal/js/md5.js"></script>
    <script type="text/javascript" src="system/plugin/captive_portal/js/sweetalert2.all.min.js"></script>

</head>

<body id="app" class="app off-canvas body-full">

    <div class="container">
        <!-- <div class="hidden-xs" style="height:150px"></div> -->
        
        {if isset($notify)}
        <script>
            // Display SweetAlert toast notification
            Swal.fire({
                icon: '{if $notify_t == "s"}success{else}warning{/if}',
                title: '{$notify}',
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 5000,
                timerProgressBar: true,
                didOpen: (toast) => {
                    toast.addEventListener('mouseenter', Swal.stopTimer)
                    toast.addEventListener('mouseleave', Swal.resumeTimer)
                }
            });
        </script>
        {/if}

    <body>
        <nav class="navbar  fixed-top">
            <div class="container">
                <a class="navbar-brand" href="#">
      {if $config.logo}
        <img src="{$config.logo}" alt="Logo" width="100" height="35" class="d-inline-block align-top">
      {else}
        {$config.hotspot_name}
      {/if}
    </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon "></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNavDropdown">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item active">
                            <a class="nav-link text-white" href="#">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">About Us</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-white" href="#">contact us</a>
                        </li>
                        
                    </ul>
                </div>
            </div>
        </nav>
    
        <br>
        <br>
    
        <header id="header">
            <div id="headerCarousel" class="carousel slide carousel-fade" data-ride="carousel">
                <!-- Slide Indicators -->
                <ol class="carousel-indicators">
                    {foreach $sliderData as $key => $slide}
                    <li data-target="#headerCarousel" data-slide-to="{$key}" {if $key==0 }class="active" {/if}></li>
                    {/foreach}
                </ol>
    
                <div class="carousel-inner" role="listbox">
                    {foreach $slides as $key => $slide}
                    <div class="carousel-item {if $key == 0}active{/if}">
                        <div class="carousel-background"><img src="{$slide.image}" alt=""></div>
                        <div class="carousel-container">
                            <div class="carousel-content">
                                <h2>{$slide.title}</h2>
                                <p>{$slide.description}</p>
                                {if $slide.button}
                                <a href="{$slide.link}" class="contactus-btn">{$slide.button}</a> {/if}
                            </div>
                        </div>
                    </div>
                    {/foreach}
                </div>
    
                <!-- Carousel pre and next arrow -->
                <a class="carousel-control-prev" href="#headerCarousel" role="button" data-slide="prev">
                    <i class="fa fa-chevron-left"></i>
                </a>
                <a class="carousel-control-next" href="#headerCarousel" role="button" data-slide="next">
                    <i class="fa fa-chevron-right"></i>
                </a>
            </div>
        </header>
        <div id="login" class="moda" tabindex="-1">
            <div class="modal-dialog">
                <div style="overflow-x:auto;margin-top:2rem" class="modal-content">
                    <div style="overflow-x:auto;" class="modal-header">
                        <h5 class="modal-title">{$_c['CompanyName']}</h5>
                       
                    </div>
                    <div class="modal-body">
                        {if {$error}}
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <strong>oops!</strong> {$error}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div> {/if}
                        <form name="login" action="{$_url}register/post" method="post" {if isset($chapid)} onSubmit="return doLogin()" {/if}>
                            <input type="hidden" name="dst" value="http://google.com">
                            <input type="hidden" name="popup" value="true">
                            <div class="form-group">
                                <label for="username">Phone number</label>
                                <input type="text" class="form-control" name="username" id="username" placeholder="Enter your phone number" required>
                            </div>
                            <div class="form-group">
                                <label>{Lang::T('Full Name')}</label>
                                <input type="text" required class="form-control" id="fullname" value="{$fullname}"
                                    name="fullname">
                            </div>
                            <div class="form-group">
                                
                                <input type="hidden" required class="form-control" id="email"
                                    placeholder="xxxxxxx@xxxx.xx" value="info@gmail.com" name="email">
                            </div>
                            <div class="form-group">
                                <label>{Lang::T('Password')}</label>
                                <input type="password" required class="form-control" id="password" name="password">
                            </div>
                            <div class="form-group">
                                <label>{Lang::T('Confirm Password')}</label>
                                <input type="password" required class="form-control" id="cpassword"
                                    name="cpassword">
                            </div>
                            <button type="submit" class="btn login-button text-white btn-block">Register</button>
                        </form>
                        <br>
                        <div class="text-center"><span class="text-muted">Have an account?</span> <a href="{$_url}login">Login here</a></div>
                    </div>
                    <div class="">
                        <div class="text-center p-t-136">
                            <hr> Powered by:
                            <a class="txt2" href="./"> {$config.hotspot_name} </a>
                            <br> All Rights Reserved
                            <br> &copy; {$smarty.now|date_format:"%Y"}
    
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    
        <!-- <div class="footer"> -->
        
        </div>
    
    
        
        <!-- <script type="text/javascript">
            document.login.username.focus();
        </script> -->
    </body>





    {if $_c['tawkto'] != ''}
        <!--Start of Tawk.to Script-->
        <script type="text/javascript">
            var Tawk_API = Tawk_API || {},
                Tawk_LoadStart = new Date();
            (function() {
                var s1 = document.createElement("script"),
                    s0 = document.getElementsByTagName("script")[0];
                s1.async = true;
                s1.src='https://embed.tawk.to/{$_c['tawkto']}';
                s1.charset = 'UTF-8';
                s1.setAttribute('crossorigin', '*');
                s0.parentNode.insertBefore(s1, s0);
            })();
        </script>
        <!--End of Tawk.to Script-->
    {/if}
    <script src="ui/ui/scripts/vendors.js?v=1"></script>
</body>

</html>