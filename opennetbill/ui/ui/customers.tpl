{include file="sections/header.tpl"}
<div class="row">
    <div class="card">
        <div class="card-header">
            <div class=" card-title">{Lang::T('Manage Customers')}
               <a class="btn sm_button" title="save" href="{$_url}customers/add" aria-hidden="true"></span> Add</a>
            </div>
            	<div class="card-title">
							
                        				<form class="add" id="site-search" method="post" action="{$_url}customers/list/">
											<div class="input-group">
                                                <input type="text" id="search-input" name="search" value="{$search}" class="form-control" placeholder="{Lang::T('Search')}...">
                                            <div class="input-group-btn">
                                                <button class="btn btn-success" type="submit"><span class="fa fa-search"></span></button>
                                                </div>
                                            </div
										</form>
				</div>
            <div class="card-body">
              
                <div class="table-responsive table_mobile">
                    <table class="table table-bordered table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>{Lang::T('Username')}</th>
                                <th>{Lang::T('Account')}</th>
                                <th>{Lang::T('Full Name')}</th>
                                <th>{Lang::T('Phone')}</th>
                                <th>{Lang::T('Email')}</th>
                                <th>{Lang::T('Account No')}</th>
                                <th>{Lang::T('Service Type')}</th>
                                <th>{Lang::T('CreatedOn')}</th>
                                <th>{Lang::T('Manage')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $d as $ds}
                                <tr>
                                    <td onclick="window.location.href = '{$_url}customers/view/{$ds['id']}'"
                                        style="cursor:pointer;">{$ds['username']}</td>
                                          <td>{$ds['account_type']}</td>
                                    <td onclick="window.location.href = '{$_url}customers/view/{$ds['id']}'"
                                        style="cursor: pointer;">{$ds['fullname']}</td>
                                    <td>{$ds['phonenumber']}</td>
                                    <td>{$ds['email']}</td>
                                    <td>{$ds['address']}</td>
                                    <td>{$ds['service_type']}</td>
                                  
                                    <td>{Lang::dateTimeFormat($ds['created_at'])}</td>
                                    <td align="center">
                                        <a href="{$_url}customers/view/{$ds['id']}" id="{$ds['id']}" style="margin: 0px;"
                                            class="btn btn-success btn-xs">&nbsp;&nbsp;{Lang::T('View')}&nbsp;&nbsp;</a>
                                        <a href="{$_url}plan/recharge/{$ds['id']}" id="{$ds['id']}" style="margin: 0px;"
                                            class="btn btn-primary btn-xs">{Lang::T('Recharge')}</a>
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
<script>
    // Functionality to filter table rows based on admin input
    document.addEventListener('DOMContentLoaded', function () {
            var searchInput = document.getElementById('search-input');
            var tableRows = document.querySelectorAll('tbody tr');

            searchInput.addEventListener('input', function () {
                var searchText = this.value.toLowerCase();

                tableRows.forEach(function (row) {
                    var rowData = row.textContent.toLowerCase();

                    if (rowData.includes(searchText)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });
</script>
{include file="sections/footer.tpl"}
