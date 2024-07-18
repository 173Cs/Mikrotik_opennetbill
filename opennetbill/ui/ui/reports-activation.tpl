{include file="sections/header.tpl"}
<!-- pool -->
<div class="row">
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                Activity Log
            </div>
              <div class="card-title">
							
                        				<form class="add" id="site-search" method="post"  action="{$_url}reports/activation">
											<div class="input-group">
                                                <input type="text" id="search-input" name="search" value="{$search}" class="form-control" placeholder="{Lang::T('Search')}...">
                                            <div class="input-group-btn">
                                                <button class="btn btn-success" type="submit"><span class="fa fa-search"></span></button>
                                                </div>
                                            </div
										</form>
				</div>
            <div class="card-body">
                <br>
                <div class="table-responsive">
                    <table id="datatable" class="table table-bordered table-striped">
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
                                <tr>
                                    <td onclick="window.location.href = '{$_url}plan/view/{$ds['id']}'"
                                    style="cursor:pointer;">{$ds['invoice']}</td>
                                    <td onclick="window.location.href = '{$_url}customers/viewu/{$ds['username']}'"
                                    style="cursor:pointer;">{$ds['username']}</td>
                                    <td>{$ds['plan_name']}</td>
                                    <td>{Lang::moneyFormat($ds['price'])}</td>
                                    <td>{$ds['type']}</td>
                                    <td class="text-success">
                                        {Lang::dateAndTimeFormat($ds['recharged_on'],$ds['recharged_time'])}
                                    </td>
                                    <td class="text-danger">{Lang::dateAndTimeFormat($ds['expiration'],$ds['time'])}</td>
                                    <td>{$ds['method']}</td>
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