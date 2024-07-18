{include file="sections/user-header.tpl"}
<!-- user-orderPlan -->
<style>
/* Card Container */
.plan-box {
  font-family: 'Poppins', sans-serif; /* Add Poppins font */
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
  text-align: center; /* Center align content */
}
/* Card Header */
.box-header {
  font-family: 'Poppins', sans-serif; /* Add Poppins font */
  font-size: 1.2em;
  font-weight: bold;
  margin-bottom: 10px;
}

/* Price Styling */
.table-cell {
  display: table-cell;
  padding: 10px 0; /* Increased padding */
}

.table-cell:nth-child(2) {
  font-size: 1.5em; /* Bigger font size for prices */
  font-weight: bold;
}
.price-cell{
    display:flex;
     padding: 10px 0; 
     text-align: center;
     width: 100%;
     justify-content: center;
     align-items: center;
     
}
.price-cell:nth-child(1) {
  font-size: 1.5em; /* Bigger font size for prices */
  font-weight: bold;
}

/* Table Styling */
.table {
  display: table;
  width: 100%;
}

.table-row {
  display: table-row;
}
.table-cell {
  display: table-cell;
  padding: 5px 0;
}
.btn {
  font-family: 'Poppins', sans-serif;
  display: inline-block;
  padding: 8px 15px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  text-align: center;
}
.money{
    font-size: 2rem;
}
.btn-warning {
  background-color: #f0ad4e;
  color: #fff;
}

.btn-success {
  background-color: #5cb85c;
  color: #fff;
}

.btn-block {
  width: 100%;
}
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
<div id="loader-banner" style="display: none;" class="loader-banner">
    <div class="loader"></div>
    <p>Complete transaction on your phone and wait as we validate it</p>
</div>
<div class="row">
    <div class="col-sm-12">
        {if $_c['radius_enable']}
            {if $_user['service_type'] == 'PPPoE'}
                {if Lang::arrayCount($radius_pppoe)>0}
                    <ol class="breadcrumb">
                        <li>{if $_c['radius_plan']==''}Radius Plan{else}{$_c['radius_plan']}{/if}</li>
                        <li>{if $_c['pppoe_plan']==''}PPPOE Plan{else}{$_c['pppoe_plan']}{/if}</li>
                    </ol>
                    <div class="row">
                       
                    </div>
                {/if}
            {elseif $_user['service_type'] == 'Hotspot'}
                {if Lang::arrayCount($radius_hotspot)>0}
                    <ol class="breadcrumb">
                        <li>{if $_c['radius_plan']==''}Radius Plan{else}{$_c['radius_plan']}{/if}</li>
                        <li>{if $_c['hotspot_plan']==''}Hotspot Plan{else}{$_c['hotspot_plan']}{/if}</li>
                    </ol>
                    <div class="row">
                        {foreach $radius_hotspot as $plan}
                            <div class="col col-md-4">
                                <div class="">
                                    <div class="box-header text-bold">{$plan['name_plan']}</div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <tbody>
                                                <tr>
                                                    <td>{Lang::T('Type')}</td>
                                                    <td>{$plan['type']}</td>
                                                </tr>
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
                                        <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                            <a href="{$_url}order/buy/radius/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this? your active package will be overwrite')}')"
                                                class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                            {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                <a href="{$_url}order/pay/radius/{$plan['id']}"
                                                    onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwrite')}')"
                                                    class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                            {/if}
                                        </div>
                                        {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                            <a href="{$_url}order/send/radius/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {/if}
            {elseif $_user['service_type'] == 'Others' || $_user['service_type'] == '' && (Lang::arrayCount($radius_pppoe)>0 || Lang::arrayCount($radius_hotspot)>0)}
                <ol class="breadcrumb">
                    <li>{if $_c['radius_plan']==''}Radius Plan{else}{$_c['radius_plan']}{/if}</li>
                    <li>{if $_c['pppoe_plan']==''}PPPOE Plan{else}{$_c['pppoe_plan']}{/if}</li>
                </ol>
                {if Lang::arrayCount($radius_pppoe)>0}
                    <div class="row">
                        {foreach $radius_pppoe as $plan}
                            <div class="col col-md-4">
                                <div class="box box-primary">
                                    <div class="box-header text-bold">{$plan['name_plan']}</div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <tbody>
                                                <tr>
                                                    <td>{Lang::T('Type')}</td>
                                                    <td>{$plan['type']}</td>
                                                </tr>
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
                                        <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                            <a href="{$_url}order/gateway/pppoe/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this? your active package will be overwritten')}')"
                                                class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                            {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                <a href="{$_url}order/pay/pppoe/{$plan['id']}"
                                                    onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwritten')}')"
                                                    class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                            {/if}
                                        </div>
                                        {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                            <a href="{$_url}order/send/pppoe/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {/if}
                {if Lang::arrayCount($radius_hotspot)>0}
                    <ol class="breadcrumb">
                        <li>{if $_c['radius_plan']==''}Radius Plan{else}{$_c['radius_plan']}{/if}</li>
                        <li>{if $_c['hotspot_plan']==''}Hotspot Plan{else}{$_c['hotspot_plan']}{/if}</li>
                    </ol>
                    <div class="row">
                        {foreach $radius_hotspot as $plan}
                            <div class="col col-md-4">
                                <div class="box box-primary">
                                    <div class="box-header text-bold">{$plan['name_plan']}</div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-striped">
                                            <tbody>
                                                <tr>
                                                    <td>{Lang::T('Type')}</td>
                                                    <td>{$plan['type']}</td>
                                                </tr>
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
                                        <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                            <a href="{$_url}order/gateway/hotspot/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this? your active package will be overwritten')}')"
                                                class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                            {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                <a href="{$_url}order/pay/hotspot/{$plan['id']}"
                                                    onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwritten')}')"
                                                    class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                            {/if}
                                        </div>
                                        {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                            <a href="{$_url}order/send/hotspot/{$plan['id']}"
                                                onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {/if}
            {/if}
        {/if}
        {foreach $routers as $router}
            {if Validator::isRouterHasPlan($plans_hotspot, $router['name']) || Validator::isRouterHasPlan($plans_pppoe, $router['name'])}
                <div class="">

                    {if $router['description'] != ''}
                        <div class="box-body">
                            {$router['description']}
                        </div>
                    {/if}
                    {if $_user['service_type'] == 'Hotspot' && Validator::countRouterPlan($plans_hotspot, $router['name'])>0}
                       
                        <div class="box-body row">
                            {foreach $plans_hotspot as $plan}
                                {if $router['name'] eq $plan['routers']}
                                    <div class="col col-md-4">
                                        <div class="box box-primary">
                                            <div class="box-header text-center text-bold">{$plan['name_plan']}</div>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-striped">
                                                    <tbody>
                                                        <tr>
                                                            <td>{Lang::T('Type')}</td>
                                                            <td>{$plan['type']}</td>
                                                        </tr>
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
                                                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                                    <a href="{$_url}order/buy/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this? your active package will be overwrite')}')"
                                                        class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                                    {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                        <a href="{$_url}order/pay/{$router['id']}/{$plan['id']}"
                                                            onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwrite')}')"
                                                            class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                                    {/if}
                                                </div>
                                                {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                                    <a href="{$_url}order/send/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                        class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            {/foreach}
                        </div>
                    {/if}
                    {if $_user['service_type'] == 'PPPoE' && Validator::countRouterPlan($plans_pppoe,$router['name'])>0}
                        <div class="box-header text-white">{if $_c['pppoe_plan']==''}PPPOE Plan{else}{$_c['pppoe_plan']}{/if}</div>
                        <div class="box-body row">
                            {foreach $plans_pppoe as $plan}
                                {if $router['name'] eq $plan['routers']}
                                    <div class="col col-md-4">
                                        <div class="box box- box-primary">
                                            <div class="box-header text-bold text-center">{$plan['name_plan']}</div>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-striped">
                                                    <tbody>
                                                        <tr>
                                                            <td>{Lang::T('Type')}</td>
                                                            <td>{$plan['type']}</td>
                                                        </tr>
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
                                                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                                    <a href="{$_url}order/buy/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this? your active package will be overwrite')}')"
                                                        class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                                    {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                        <a href="{$_url}order/pay/{$router['id']}/{$plan['id']}"
                                                            onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwrite')}')"
                                                            class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                                    {/if}
                                                </div>
                                                {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                                    <a href="{$_url}order/send/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                        class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            {/foreach}
                        </div>
                    {/if}
                    {if $_user['service_type'] == 'Others' || $_user['service_type'] == '' && (Validator::countRouterPlan($plans_hotspot, $router['name'])>0 || Validator::countRouterPlan($plans_pppoe, $router['name'])>0)}
                        
                        <div class="box-body row">
                            <div class="row">
                                {foreach $plans_hotspot as $plan}
                                {if $router['name'] eq $plan['routers']}
                                  <div class="col col-md-4">
                                    <div class="plan-box">
                                      <div class="box-header text-center text-bold">{$plan['name_plan']}</div>
                                      <div class="text-center text-bold">
                                        <div class="price-cell">
                                            <div class="money">{Lang::moneyFormat($plan['price'])}</div>
                                        </div> 
                                      </div>
                                      <div class="table-responsive">
                                        <div class="table ">
                                          <div class="table-row">
                                            <div class="table-cell">Validity</div>
                                            <div class="table-cell">{$plan['validity']} {$plan['validity_unit']}</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="box-body">
                                        <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                          <a href="{$_url}order/buy/{$router['id']}/{$plan['id']}" onclick="return showLoaderBanner();" class="btn btn-sm btn-block btn-primary text-white">Buy Now</a>
                                          {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                            <a href="{$_url}order/pay/{$router['id']}/{$plan['id']}" onclick="return confirm('{Lang::T('Pay this with Balance? Your active package will be overwritten')}')" class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                          {/if}
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                                {/if}
                              {/foreach}
                              
                            </div>                              
                        </div>
                        <div class="box-header text-white">{if $_c['pppoe_plan']==''}PPPOE Plan{else}{$_c['pppoe_plan']}{/if}</div>
                        <div class="box-body row">
                            {foreach $plans_pppoe as $plan}
                                {if $router['name'] eq $plan['routers']}
                                    <div class="col col-md-4">
                                        <div class="box box- box-primary">
                                            <div class="box-header text-bold text-center">{$plan['name_plan']}</div>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-striped">
                                                    <tbody>
                                                        <tr>
                                                            <td>{Lang::T('Type')}</td>
                                                            <td>{$plan['type']}</td>
                                                        </tr>
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
                                                <div class="btn-group btn-group-justified" role="group" aria-label="...">
                                                    <a href="{$_url}order/buy/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this? your active package will be overwrite')}')"
                                                        class="btn btn-sm btn-block btn-warning text-black">Buy</a>
                                                    {if $_c['enable_balance'] == 'yes' && $_user['balance']>=$plan['price']}
                                                        <a href="{$_url}order/pay/{$router['id']}/{$plan['id']}"
                                                            onclick="return confirm('{Lang::T('Pay this with Balance? your active package will be overwrite')}')"
                                                            class="btn btn-sm btn-block btn-success">{Lang::T('Pay With Balance')}</a>
                                                    {/if}
                                                </div>
                                                {if $_c['enable_balance'] == 'yes' && $_c['allow_balance_transfer'] == 'yes' && $_user['balance']>=$plan['price']}
                                                    <a href="{$_url}order/send/{$router['id']}/{$plan['id']}"
                                                        onclick="return confirm('{Lang::T('Buy this for friend account?')}')"
                                                        class="btn btn-sm btn-block btn-primary">{Lang::T('Buy for friend')}</a>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            {/foreach}
                        </div>
                    {/if}
                </div>
            {/if}
        {/foreach}
    </div>
    <script>
        function showLoaderBanner() {
            document.getElementById('loader-banner').style.display = 'block';
            return true; 
        }
    </script>
</div>
{include file="sections/user-footer.tpl"}