{include file="sections/header.tpl"}
<!-- pool -->
<div class="row">
    <div class="card">
        <div class="card-header">
            <div class="card-title">
                {Lang::T('IP Pool')}
               <a class="btn sm_button" title="save" href="{$_url}pool/add" aria-hidden="true"></span> Add</a>

            </div>
             <div class="card-title">
							
                        				<form class="add" id="site-search" method="post"  action="{$_url}pool/list/">
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
                                <th>{Lang::T('Name Pool')}</th>
                                <th>{Lang::T('Range IP')}</th>
                                <th>{Lang::T('Routers')}</th>
                                <th>{Lang::T('Manage')}</th>
                                <th>ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr>
                                    <td>{$ds['pool_name']}</td>
                                    <td>{$ds['range_ip']}</td>
                                    <td>{$ds['routers']}</td>
                                    <td align="center">
                                        <a href="{$_url}pool/edit/{$ds['id']}" class="btn btn-info btn-xs">{Lang::T('Edit')}</a>
                                        <a href="{$_url}pool/delete/{$ds['id']}" id="{$ds['id']}"
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