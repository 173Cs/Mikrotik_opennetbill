{include file="sections/header.tpl"}

<div class="row">
    <div class="col-sm-4 col-md-4">
        <div class="box box-primary">
            <div class="box-body box-profile">
                <img class="profile-user-img img-responsive img-circle"
                    src="https://robohash.org/{$d['id']}?set=set3&size=100x100&bgset=bg1"
                    onerror="this.src='{$UPLOAD_PATH}/user.default.jpg'" alt="avatar">

                <h3 class="profile-username text-center">{$d['fullname']}</h3>

                <ul class="list-group list-group-unbordered">
                    <li class="list-group-item">
                        <b>{Lang::T('Username')}</b> <span class="pull-right">{$d['username']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Phone Number')}</b> <span class="pull-right">{$d['phonenumber']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Email')}</b> <span class="pull-right">{$d['email']}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Account Number')}</b> <span class="pull-right">{$d['address']}</span>
                    </li>
                </ul>
                <ul class="list-group list-group-unbordered">
                    <li class="list-group-item">
                        <b>{Lang::T('Password')}</b> <input type="password" value="{$d['password']}"
                            style=" border: 0px; text-align: right;" class="pull-right"
                            onmouseleave="this.type = 'password'" onmouseenter="this.type = 'text'"
                            onclick="this.select()">
                    </li>
                    {if $d['pppoe_password'] != ''}
                    <li class="list-group-item">
                        <b>PPPOE {Lang::T('Password')}</b> <input type="password" value="{$d['pppoe_password']}"
                            style=" border: 0px; text-align: right;" class="pull-right"
                            onmouseleave="this.type = 'password'" onmouseenter="this.type = 'text'"
                            onclick="this.select()">
                    </li>
                    {/if}
                    <li class="list-group-item">
                        <b>{Lang::T('Coordinates')}</b> <span class="pull-right">{$d['coordinates']}</span>
                    </li>
                    <!--Customers Attributes view start -->
                    {if $customFields}
                    {foreach $customFields as $customField}
                    <li class="list-group-item">
                        <b>{$customField.field_name}</b> <span class="pull-right">
                            {if strpos($customField.field_value, ':0') === false}
                            {$customField.field_value}
                            {else}
                            <b>{Lang::T('Paid')}</b>
                            {/if}
                        </span>
                    </li>
                    {/foreach}
                    {/if}
                    <!--Customers Attributes view end -->
                    <li class="list-group-item">
                        <b>{Lang::T('Service Type')}</b> <span class="pull-right">{Lang::T($d['service_type'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Account Type')}</b> <span class="pull-right">{Lang::T($d['account_type'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Balance')}</b> <span class="pull-right">{Lang::moneyFormat($d['balance'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Auto Renewal')}</b> <span class="pull-right">{if
                            $d['auto_renewal']}yes{else}no
                            {/if}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Created On')}</b> <span
                            class="pull-right">{Lang::dateTimeFormat($d['created_at'])}</span>
                    </li>
                    <li class="list-group-item">
                        <b>{Lang::T('Last Login')}</b> <span
                            class="pull-right">{Lang::dateTimeFormat($d['last_login'])}</span>
                    </li>
                </ul>
                <div class="row">
                    <div class="col-xs-4">
                        <a href="{$_url}customers/delete/{$d['id']}" id="{$d['id']}"
                            class="btn btn-danger btn-block btn-sm"
                            onclick="return confirm('{Lang::T('Delete')}?')"><span class="fa fa-trash"></span></a>
                    </div>
                    <div class="col-xs-8">
                        <a href="{$_url}customers/edit/{$d['id']}"
                            class="btn btn-warning btn-sm btn-block">{Lang::T('Edit')}</a>
                    </div>
                </div>
            </div>
        </div>
        {foreach $packages as $package}
        <div class="box box-{if $package['status']=='on'}success{else}danger{/if}">
            <div class="box-body box-profile">
                <h4 class="text-center">{$package['type']} - {$package['namebp']}</h4>
                <ul class="list-group list-group-unbordered">
                    <li class="list-group-item">
                        {Lang::T('Active')} <span class="pull-right">{if
                            $package['status']=='on'}yes{else}no
                            {/if}</span>
                    </li>
                    <li class="list-group-item">
                        {Lang::T('Type')} <span class="pull-right">
                            {if $package['prepaid'] eq yes}Prepaid{else}<b>Postpaid</b>{/if}</span>
                    </li>
                    <li class="list-group-item">
                        {Lang::T('Created On')} <span
                            class="pull-right">{Lang::dateAndTimeFormat($package['recharged_on'],$package['recharged_time'])}</span>
                    </li>
                    <li class="list-group-item">
                        {Lang::T('Expires On')} <span
                            class="pull-right">{Lang::dateAndTimeFormat($package['expiration'],
                            $package['time'])}</span>
                    </li>
                    <li class="list-group-item">
                        {$package['routers']} <span class="pull-right">{$package['method']}</span>
                    </li>
                </ul>
                <div class="row">
                    <div class="col-xs-4">
                        <a href="{$_url}customers/deactivate/{$d['id']}/{$package['plan_id']}" id="{$d['id']}"
                            class="btn btn-danger btn-block btn-sm"
                            onclick="return confirm('This will deactivate Customer Plan, and make it expired')">{Lang::T('Deactivate')}</a>
                    </div>
                    <div class="col-xs-8">
                        <a href="{$_url}customers/recharge/{$d['id']}/{$package['plan_id']}"
                            class="btn btn-success btn-sm btn-block">{Lang::T('Recharge')}</a>
                    </div>
                </div>
            </div>
        </div>
        {/foreach}
        <div class="row">
            <div class="col-xs-4">
                <a href="{$_url}customers/list" class="btn btn-primary btn-sm btn-block">{Lang::T('Back')}</a>
            </div>
            <div class="col-xs-4">
                <a href="{$_url}customers/sync/{$d['id']}"
                    onclick="return confirm('This will sync Customer to Mikrotik?')"
                    class="btn btn-info btn-sm btn-block">{Lang::T('Sync')}</a>
            </div>
            <div class="col-xs-4">
                <a href="{$_url}message/send/{$d['id']}" class="btn btn-success btn-sm btn-block">{Lang::T('Send
                    Message')}</a>
            </div>
        </div>
    </div>
    <div class="col-sm-8 col-md-8">
        <ul class="nav nav-tabs">
            <li role="presentation" {if $v=='order' }class="active" {/if}><a
                    href="{$_url}customers/view/{$d['id']}/order">30 {Lang::T('Order History')}</a></li>
            <li role="presentation" {if $v=='activation' }class="active" {/if}><a
                    href="{$_url}customers/view/{$d['id']}/activation">30 {Lang::T('Activation History')}</a></li>
            <li role="presentation" {if $v=='session' }class="active" {/if}><a
                    href="{$_url}customers/view/{$d['id']}/session">30 {Lang::T('Session')}</a></li>        
        </ul>
        <div class="table-responsive" style="background-color: white;">
            <table id="datatable" class="table table-bordered table-striped">
                {if Lang::arrayCount($activation)}
                <thead>
                    <tr>
                        <th>{Lang::T('Invoice')}</th>
                        <th>{Lang::T('Username')}</th>
                        <th>{Lang::T('Plan Name')}</th>
                        <th>{Lang::T('Plan Price')}</th>
                        <th>{Lang::T('Type')}</th>
                        <th>{Lang::T('Created On')}</th>
                        <th>{Lang::T('Expires On')}</th>
                        <th>{Lang::T('Method')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $activation as $ds}
                    <tr onclick="window.location.href = '{$_url}plan/view/{$ds['id']}'" style="cursor:pointer;">
                        <td>{$ds['invoice']}</td>
                        <td>{$ds['username']}</td>
                        <td>{$ds['plan_name']}</td>
                        <td>{Lang::moneyFormat($ds['price'])}</td>
                        <td>{$ds['type']}</td>
                        <td class="text-success">{Lang::dateAndTimeFormat($ds['recharged_on'],$ds['recharged_time'])}
                        </td>
                        <td class="text-danger">{Lang::dateAndTimeFormat($ds['expiration'],$ds['time'])}</td>
                        <td>{$ds['method']}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {/if}
                {if Lang::arrayCount($order)}
                <thead>
                    <tr>
                        <th>{Lang::T('Plan Name')}</th>
                        <th>{Lang::T('Gateway')}</th>
                        <th>{Lang::T('Routers')}</th>
                        <th>{Lang::T('Type')}</th>
                        <th>{Lang::T('Plan Price')}</th>
                        <th>{Lang::T('Created On')}</th>
                        <th>{Lang::T('Expires On')}</th>
                        <th>{Lang::T('Date Done')}</th>
                        <th>{Lang::T('Method')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $order as $ds}
                    <tr>
                        <td>{$ds['plan_name']}</td>
                        <td>{$ds['gateway']}</td>
                        <td>{$ds['routers']}</td>
                        <td>{$ds['payment_channel']}</td>
                        <td>{Lang::moneyFormat($ds['price'])}</td>
                        <td class="text-primary">{Lang::dateTimeFormat($ds['created_date'])}</td>
                        <td class="text-danger">{Lang::dateTimeFormat($ds['expired_date'])}</td>
                        <td class="text-success">{if $ds['status']!=1}{Lang::dateTimeFormat($ds['paid_date'])}{/if}</td>
                        <td>{if $ds['status']==1}{Lang::T('UNPAID')}
                            {elseif $ds['status']==2}{Lang::T('PAID')}
                            {elseif $ds['status']==3}{$_L['FAILED']}
                            {elseif $ds['status']==4}{Lang::T('CANCELED')}
                            {elseif $ds['status']==5}{Lang::T('UNKNOWN')}
                            {/if}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {/if}
                {if Lang::arrayCount($session)}
                {if $session_type=="Hotspot"}
                <thead>
                 <tr>
                    <th>Username</th>
                    <th>IP Address</th>
                    <th>Uptime</th>
                    <th>Server</th>
                    <th>Mac Address</th>
                    <th>Session Time Left</th>
                    <th>RX</th>
                    <th>TX</th>
                    <th>Total Usage</th>
                    <!--  <th>Action</th>  -->
                  </tr>
                </thead>
                <tbody>
                    {foreach $session as $s}
                     <tr>
                        <td>{$s.username}</td>
                        <td>{$s.address}</td>
                        <td>{$s.uptime}</td>
                        <td>{$s.server}</td>
                        <td>{$s.mac}</td>
                        <td>{$s.session_time}</td>
                        <td>{$s.rx_bytes}</td>
                        <td>{$s.tx_bytes}</td>
                        <td>{$s.total}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {/if}
                {if $session_type=="PPPoE"}
                <thead>
                  <tr>
                    <th>Username</th>
                    <th>IP Address</th>
                    <th>Uptime</th>
                    <th>Service</th>
                    <th>Caller ID</th>
                    <th>bytes In</th>
                    <th>bytes Out</th>
                  </tr>
                </thead>
                <tbody>
                {foreach $session as $s}
                <tr>
                 <td>{$s.username}</td>
                 <td>{$s.address}</td>
                 <td>{$s.uptime}</td>
                 <td>{$s.service}</td>
                 <td>{$s.caller_id}</td>
                 <td>{$s.bytes_in}</td>
                 <td>{$s.bytes_out}</td>
                </tr>
                    {/foreach}
                </tbody>
                {/if}
                {/if}
            </table>
        </div>
        {$paginator['contents']}
    </div>
</div>

{include file="sections/footer.tpl"}