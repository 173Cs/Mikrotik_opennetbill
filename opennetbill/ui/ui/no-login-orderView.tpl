<!-- user-orderView -->

<!doctype html>
<html>
<head>
    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/themes/net_bill/css/style.css">
         <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="ui/ui/fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="ui/ui/fonts/font-awesome/css/font-awesome.min.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">
    <link rel="stylesheet" href="ui/ui/styles/select2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/select2-bootstrap.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/style.css" />
    <link rel="stylesheet" href="ui/ui/styles/sweetalert2.min.css" />
    <link rel="stylesheet" href="ui/ui/styles/plugins/pace.css" />
    <script src="ui/ui/scripts/sweetalert2.all.min.js"></script>
</head>

  <body>
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

<div class="hidden-xs" style="height:30px"></div>
<div class="form-head mb20">
<h1 class="site-logo h2 mb5 mt5 text-center text-uppercase text-bold"
style="text-shadow: 2px 2px 4px #757575;">{$_c['CompanyName']}</h1>
<hr>
</div>
<div class="alert alert-success">
<div>{$instructions}</div>
</div>
<div class="row">
    <div class="col-md-3"></div>
    <div class="col-md-6">
        <div
            class="panel mb20 {if $trx['status']==1}panel-warning{elseif $trx['status']==2}panel-success{elseif $trx['status']==3}panel-danger{elseif $trx['status']==4}panel-danger{else}panel-primary{/if} panel-hovered">
            <div class="panel-footer">Transaction #{$trx['id']}</div>
            {if !in_array($trx['routers'],['balance','radius'])}
                <div class="panel-body">
                    <div class="panel panel-primary panel-hovered">
                        <div class="panel-heading">{$router['name']}</div>
                        <div class="panel-body">
                            {$router['description']}
                        </div>
                    </div>
                </div>
            {/if}
            <div class="table-responsive">
                {if $trx['pg_url_payment']=='balance'}
                    <table class="table table-bordered table-striped table-bordered">
                        <tbody>
                            <tr>
                                <td>{Lang::T('Type')}</td>
                                <td>{$trx['plan_name']}</td>
                            </tr>
                            <tr>
                                <td>{Lang::T('Paid Date')}</td>
                                <td>{date($_c['date_format'], strtotime($trx['paid_date']))}
                                    {date('H:i', strtotime($trx['paid_date']))} </td>
                            </tr>
                            <tr>
                                {if $trx['plan_name'] == 'Receive Balance'}
                                    <td>{Lang::T('From')}</td>
                                {else}
                                    <td>{Lang::T('To')}</td>
                                {/if}
                                <td>{$trx['gateway']}</td>
                            </tr>
                            <tr>
                                <td>{Lang::T('Balance')}</td>
                                <td>{Lang::moneyFormat($trx['price'])}</td>
                            </tr>
                        </tbody>
                    </table>
                {else}
                    <table class="table table-bordered table-striped table-bordered">
                        <tbody>
                            <tr>
                                <td>{Lang::T('Status')}</td>
                                <td>{if $trx['status']==1}{Lang::T('UNPAID')}{elseif $trx['status']==2}{Lang::T('PAID')}{elseif $trx['status']==3}{Lang::T('FAILED')}{elseif $trx['status']==4}{Lang::T('CANCELED')}{else}{Lang::T('UNKNOWN')}{/if}
                                </td>
                            </tr>
                            <tr>
                                <td>{Lang::T('expired')}</td>
                                <td>{date($_c['date_format'], strtotime($trx['expired_date']))}
                                    {date('H:i', strtotime($trx['expired_date']))} </td>
                            </tr>
                            {if $trx['status']==2}
                                <tr>
                                    <td>{Lang::T('Paid Date')}</td>
                                    <td>{date($_c['date_format'], strtotime($trx['paid_date']))}
                                        {date('H:i', strtotime($trx['paid_date']))} </td>
                                </tr>
                            {/if}
                            <tr>
                                <td>{Lang::T('Plan Name')}</td>
                                <td>{$plan['name_plan']}</td>
                            </tr>
                            {if $add_cost>0}
                                {foreach $bills as $k => $v}
                                    <tr>
                                        <td>{$k}</td>
                                        <td>{Lang::moneyFormat($v)}</td>
                                    </tr>
                                {/foreach}
                                <tr>
                                    <td>{Lang::T('Additional Cost')}</td>
                                    <td>{Lang::moneyFormat($add_cost)}</td>
                                </tr>
                            {/if}
                            <tr>
                                <td>{Lang::T('Plan Price')}{if $add_cost>0}<small> + {Lang::T('Additional Cost')}{/if}</small></td>
                                <td style="font-size: large; font-weight:bolder; font-family: 'Courier New', Courier, monospace; ">{Lang::moneyFormat($trx['price'])}</td>
                            </tr>
                            <tr>
                                <td>{Lang::T('Type')}</td>
                                <td>{$plan['type']}</td>
                            </tr>
                            {if $plan['type']!='Balance'}
                                {if $plan['type'] eq 'Hotspot'}
                                    <tr>
                                        <td>{Lang::T('Plan_Type')}</td>
                                        <td>{Lang::T($plan['typebp'])}</td>
                                    </tr>
                                    {if $plan['typebp'] eq 'Limited'}
                                        {if $plan['limit_type'] eq 'Time_Limit' or $plan['limit_type'] eq 'Both_Limit'}
                                            <tr>
                                                <td>{Lang::T('Time_Limit')}</td>
                                                <td>{$ds['time_limit']} {$ds['time_unit']}</td>
                                            </tr>
                                        {/if}
                                        {if $plan['limit_type'] eq 'Data_Limit' or $plan['limit_type'] eq 'Both_Limit'}
                                            <tr>
                                                <td>{Lang::T('Data_Limit')}</td>
                                                <td>{$ds['data_limit']} {$ds['data_unit']}</td>
                                            </tr>
                                        {/if}
                                    {/if}
                                {/if}
                                <tr>
                                    <td>{Lang::T('Plan Validity')}</td>
                                    <td>{$plan['validity']} {$plan['validity_unit']}</td>
                                </tr>
                                <tr>
                                    <td>{Lang::T('Bandwidth Plans')}</td>
                                    <td>{$bandw['name_bw']}<br>{$bandw['rate_down']}{$bandw['rate_down_unit']}/{$bandw['rate_up']}{$bandw['rate_up_unit']}
                                    </td>
                                </tr>
                            {/if}
                        </tbody>
                    </table>
                {/if}
            </div>
            {if $trx['status']==1}
                <div class="panel-footer ">
                    <div class="btn-group btn-group-justified">
                        <a href="{$trx['pg_url_payment']}" {if $trx['gateway']=='midtrans'} target="_blank" {/if}
                            class="btn btn-primary">{Lang::T('PAY NOW')}</a>
                        <a href="{$_url}login/confirm/{$trx['id']}/check"
                            class="btn btn-info">{Lang::T('Confirm Payment')}</a>
                    </div>
                </div>
                <div class="panel-footer ">
                    <a href="{$_url}login/confirm/{$trx['id']}/cancel" class="btn btn-danger"
                        onclick="return confirm('{Lang::T('Cancel it?')}')">{Lang::T('Cancel')}</a>
                </div>
            {/if}
        </div>
    </div>
</div>

<script src="ui/ui/scripts/vendors.js"></script>
</body>
</html>