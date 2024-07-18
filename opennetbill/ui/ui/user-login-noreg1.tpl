<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>{Lang::T('Login')} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">


</head>
<style>.loader-banner {
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

  <body>
  <div id="loader-banner" style="display: block;" class="loader-banner">
    <div class="loader"></div>
    <p>Complete transaction on your phone and wait as we validate it</p>
</div>
  <div class="container">
        <div class="hidden-xs" style="height:150px"></div>
        <div class="form-head mb20">
            <h1 class="site-logo h2 mb5 mt5 text-center text-uppercase text-bold"
                style="text-shadow: 2px 2px 4px #757575;">{$_c['CompanyName']}</h1>
            <hr>
        </div>
        {if isset($notify)}
            <div class="alert alert-{if $notify_t == 's'}success{else}danger{/if}">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">×</span>
                </button>
                <div>{$notify}</div>
            </div>
        {/if}
    <div class="box-body row">
      {foreach $routers as $router} {if
      Validator::isRouterHasPlan($plans_hotspot, $router['name'])} {foreach
      $plans_hotspot as $plan} {if $router['name'] eq $plan['routers']}
      <div class="col col-md-4">
        <div class="box box-primary">
          <div class="box-header text-center text-bold">
            {$plan['name_plan']}
          </div>
          <div
            class="btn-group btn-group-justified"
            role="group"
            aria-label="..."
          >
            <div class="form-group">
              <div class="col-md-9">
                <div class="input-group">
                  {if $_c['country_code_phone']!= ''}
                  <span class="input-group-addon" id="basic-addon1"
                    >+{$_c['country_code_phone']}</span
                  >
                  {else}
                  <span class="input-group-addon" id="basic-addon1"
                    ><i class="glyphicon glyphicon-phone-alt"></i
                  ></span>
                  {/if}

                  <input
                    type="text"
                    class="form-control"
                    id="phoneNumber"
                    placeholder="{if $_c['country_code_phone']!= ''}{/if} {Lang::T('Enter your phone number')}"
                  />
                </div>
              </div>
            </div>
          </div>
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
          <div class="box-body">
            <div class="form-group center-button">
              <button 
                class="btn btn-sm btn-block btn-warning text-black"
               
                onclick="subscribe()"
              >
                Subscrbe
              </button>
            </div>
          </div>
        </div>
      </div>
      {/if} {/foreach} {/if} {/foreach}
    </div>
    <script>
      function subscribe() {
        var phoneNumber = document.getElementById("phoneNumber").value;
        if (phoneNumber) {
          const url =
            `{$_url}order/buy/{$router['id']}/{$plan['id']}/` +
            encodeURIComponent(phoneNumber);
          fetch(url, {
            method: "GET",
          });
        } else {
          alert("Please enter your phone number.");
        }
      }
    </script>
      <script>
        function showLoaderBanner() {
            document.getElementById('loader-banner').style.display = 'block';
            return true; 
        }
    </script>
    <script src="ui/ui/scripts/vendors.js"></script>
    </div>
  </body>
</html>