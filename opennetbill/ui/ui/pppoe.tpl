{include file="sections/header.tpl"}

<div class="row">
    <div class="card">
        <div class="card-header">
            <div class=" card-title">{Lang::T('PPPOE Plans')}
             <a class="btn sm_button" title="save" href="{$_url}services/pppoe-add" aria-hidden="true"></span> Add</a>

            </div>
            <div class="card-title">
							
                        				<form class="add" id="site-search" method="post"  action="{$_url}services/pppoe/">
											<div class="input-group">
                                                <input type="text" id="search-input" name="search" value="{$search}" class="form-control" placeholder="{Lang::T('Search')}...">
                                            <div class="input-group-btn">
                                                <button class="btn btn-success" type="submit"><span class="fa fa-search"></span></button>
                                                </div>
                                            </div
										</form>
				</div>
            <div class="card-body">
               
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>{Lang::T('Plan Name')}</th>
                                <th>{Lang::T('Plan Type')}</th>
                                <th>{Lang::T('Bandwidth Plans')}</th>
                                <th>{Lang::T('Plan Price')}</th>
                                <th>{Lang::T('Plan Validity')}</th>
                                <th>{Lang::T('IP Pool')}</th>
                                <th>{Lang::T('Expired IP Pool')}</th>
                                <th>{Lang::T('Routers')}</th>
                                <th>{Lang::T('Manage')}</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr {if $ds['enabled'] != 1}class="danger" title="disabled"{/if}>
                                    <td>{$ds['name_plan']}</td>
                                    <td>{$ds['plan_type']} {if $ds['prepaid'] != 'yes'}<b>Postpaid</b>{else}Prepaid{/if}</td>
                                    <td>{$ds['name_bw']}</td>
                                    <td>{Lang::moneyFormat($ds['price'])}</td>
                                    <td>{$ds['validity']} {$ds['validity_unit']}</td>
                                    <td>{$ds['pool']}</td>
                                    <td>{$ds['pool_expired']}{if $ds['list_expired']}
                                        {if $ds['pool_expired']} |
                                            {/if}{$ds['list_expired']}
                                        {/if}</td>
                                    <td>
                                        {if $ds['is_radius']}
                                            <span class="label label-primary">RADIUS</span>
                                        {else}
                                            {if $ds['routers']!=''}
                                                <a href="{$_url}routers/edit/0&name={$ds['routers']}">{$ds['routers']}</a>
                                            {/if}
                                        {/if}
                                    </td>
                                    <td>
                                        <a href="{$_url}services/pppoe-edit/{$ds['id']}"
                                            class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
                                        <a href="{$_url}services/pppoe-delete/{$ds['id']}"
                                            onclick="return confirm('{Lang::T('Delete')}?')" id="{$ds['id']}"
                                            class="btn btn-danger btn-xs"><i class="glyphicon glyphicon-trash"></i></a>
                                    </td>
                                    <td>{$ds['id']}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                {$paginator['contents']}
            </div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}