{include file="sections/header.tpl"}
<!-- routers -->

<div class="row">
    <div class="card">
        <div class="card-header">
            <div class="card-title">{Lang::T('Routers')}
             <a class="btn sm_button" title="save" href="{$_url}routers/add" aria-hidden="true"></span> Add</a>

            
            
            </div>
             <div class="card-title">
							
                        				<form class="add" id="site-search" method="post"  action="{$_url}routers/list/">
											<div class="input-group">
                                                <input type="text" id="search-input" name="search" value="{$search}" class="form-control" placeholder="{Lang::T('Search')}...">
                                            <div class="input-group-btn">
                                                <button class="btn btn-success" type="submit"><span class="fa fa-search"></span></button>
                                                </div>
                                            </div
										</form>
				</div>
            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>{Lang::T('Router Name')}</th>
                                <th>{Lang::T('IP Address')}</th>
                                <th>{Lang::T('Username')}</th>
                                <th>{Lang::T('Description')}</th>
                                <th>{Lang::T('Status')}</th>
                                <th>{Lang::T('Manage')}</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr {if $ds['enabled'] != 1}class="danger" title="disabled" {/if}>
                                    <td>{$ds['name']}</td>
                                    <td>{$ds['ip_address']}</td>
                                    <td>{$ds['username']}</td>
                                    <td>{$ds['description']}</td>
                                    <td>{if $ds['enabled'] == 1}Enabled{else}Disabled{/if}</td>
                                    <td>
                                        <a href="{$_url}routers/edit/{$ds['id']}"
                                            class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
                                        <a href="{$_url}routers/delete/{$ds['id']}" id="{$ds['id']}"
                                            onclick="return confirm('{Lang::T('Delete')}?')"
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