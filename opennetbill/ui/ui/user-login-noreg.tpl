<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/themes/net_bill/css/style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="ui/ui/fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="ui/ui/fonts/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">
    <link rel="stylesheet" href="ui/ui/styles/select2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/select2-bootstrap.min.css" />
    <link rel="stylesheet" href="system/plugin/captive_portal/css/style.css" />
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="ui/ui/styles/style.css" />
    <link rel="stylesheet" href="ui/ui/styles/sweetalert2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/plugins/pace.css" />
    <script src="ui/ui/scripts/sweetalert2.all.min.js"></script>
</head>

<style>
.loader-banner {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 9999; 
    background-color: white; 
    padding: 20px;
    text-align: center;
    border-radius: 10px;
}

@keyframes loading {
  from {
    transform: rotate(0turn);
  }
  to {
    transform: rotate(1turn);
  }
}

@media (max-width: 767px) {
  .col-md-4 {
    width: 100%;
  }
}
</style>
<body style="background-color:#ebf0f7">
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

    <div class="container-fluid sticky-top">
        <div class="d-flex flex-row flex-lg-row justify-content-between align-items-center">
            <div class="logo-container align-items-center">
                <h1>{$_c['CompanyName']}</h1>
            </div>
            <button class="btn btn-primary ms-2" onclick="scrollToReconnect()">Reconnect</button>
        </div>
    </div>
        <div id="loader-banner" style="display: none;" class="loader-banner">
    <div class="loader"></div>
    <p>Complete transaction on your phone and wait as we validate it</p>
    </div>
    <div class="container">
        <div class="row">
            {foreach $routers as $router} 
            {if Validator::isRouterHasPlan($plans_hotspot, $router['name'])} 
            {foreach $plans_hotspot as $plan} 
            {if $router['name'] eq $plan['routers']}
            <div class=" col-md-4 mb-4 mx-auto d-flex justify-content-center">
                <div class="card">
                    <div class="card-header text-center font-weight-bold bg-primary text-white">
                        {$plan['name_plan']}
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped">
                                <tbody>
                                    <tr>
                                        <td>{Lang::T('Price')}</td>
                                        <td>{Lang::moneyFormat($plan['price'])}</td>
                                    </tr>
                                    <tr>
                                        <td>{Lang::T('Validity')}</td>
                                        <td>{$plan['validity']} {$plan['validity_unit']}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <form id="subscriptionForm" action="{$_url}order/buy/{$router['id']}/{$plan['id']}" method="post">
                            <div class="input-group mb-3">
                                {if $_c['country_code_phone'] != ''}
                                <div class="input-group-prepend">
                                    <span class="input-group-text" id="basic-addon1">+{$_c['country_code_phone']}</span>
                                </div>
                                {else}
                                <div class="input-group-prepend">
                                    <span class="input-group-text" id="basic-addon1"><i class="glyphicon glyphicon-phone-alt"></i></span>
                                </div>
                                {/if}
                                <input type="text" class="form-control" name="phonenumber" required placeholder="{Lang::T('Enter your phone number')}">
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-success btn-block">Subscribe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            {/if} 
            {/foreach} 
            {/if} 
            {/foreach}
        </div>

        <div class="row">
            <div id="reconnect-card" class="centered col-12 col-md-4 mb-4 mx-auto">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        {Lang::T('Already Subscribed Reconnect')}
                    </div>
                    <div class="card-body">
                        <form action="{$_url}login/activation" method="post">
                            <div class="form-group">
                                <label>{Lang::T('Enter Mpesa confirmation Code here')}</label>
                                <input type="text" class="form-control" name="voucher" required autocomplete="off" placeholder="{Lang::T('SG63REZR9L')}">
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary btn-block">{Lang::T('Reconnect')}</button>
                            </div>
                            <div class="text-center mt-3">
                                <a href="./pages/Privacy_Policy.html" target="_blank">Privacy</a> &bull; 
                                <a href="./pages/Terms_of_Conditions.html" target="_blank">ToC</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="ui/ui/scripts/vendors.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function scrollToReconnect() {
            document.getElementById('reconnect-card').scrollIntoView({ behavior: 'smooth' });
        }

        function showLoaderBanner() {
            document.getElementById('loader-banner').style.display = 'block';
            return true; 
        }
    </script>
</body>

</html>