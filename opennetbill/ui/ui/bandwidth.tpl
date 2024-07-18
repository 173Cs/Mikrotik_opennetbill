{include file="sections/header.tpl"}

					<div class="row">
						<div class="card">
							<div class="card-header">
								<div class="card-title">{Lang::T('Bandwidth Plans')}
							
                        			<a class="btn sm_button" title="save" href="{$_url}bandwidth/add" aria-hidden="true"></span> Add</a>
                    			
								</div>
								<div class="card-title">
							
                        				<form class="add" id="site-search" method="post" action="{$_url}bandwidth/list/">
											<div class="input-group">
                                            <input type="text" id="search-input" name="search" value="{$search}" class="form-control" placeholder="{Lang::T('Search')}...">
                                            <div class="input-group-btn">
                                                <button class="btn btn-success" type="submit"><span class="fa fa-search"></span></button>
                                            </div>
                            </div
											</form>
								</div>
								
								<div class="card-body">
									<div class="md-whiteframe-z1 text-center" >
										
											
									<div class="table-responsive">
                                        <table class="table table-bordered table-condensed table-striped table_mobile">
                                            <thead>
                                                <tr>
                                                    <th>{Lang::T('Bandwidth Name')}</th>
                                                    <th>{Lang::T('Rate')}</th>
                                                    <th>{Lang::T('Burst')}</th>
                                                    <th>{Lang::T('Manage')}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            {foreach $d as $ds}
                                                <tr>
                                                    <td>{$ds['name_bw']}</td>
                                                    <td>{$ds['rate_down']} {$ds['rate_down_unit']} / {$ds['rate_up']} {$ds['rate_up_unit']}</td>
                                                    <td>{$ds['burst']}</td>
                                                    <td>
                                                        <a href="{$_url}bandwidth/edit/{$ds['id']}" class="btn btn-sm btn-warning">{Lang::T('Edit')}</a>
                                                        <a href="{$_url}bandwidth/delete/{$ds['id']}" id="{$ds['id']}" class="btn btn-danger btn-sm" onclick="return confirm('{Lang::T('Delete')}?')" ><i class="glyphicon glyphicon-trash"></i></a>
                                                    </td>
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
			</div>

{include file="sections/footer.tpl"}