{include file="sections/header.tpl"}

<div class="row">
    <div class="card">
        <div class="card-header">
            <div class="card-title">Backup Database</div>
            <form method="post" action="{$_url}settings/dbbackup">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th width="50%">{Lang::T('Table Name')}</th>
                                <th>{Lang::T('Rows')}</th>
                                <th>Select</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $tables as $tbl}
                                <tr>
                                    <td>{$tbl['name']}</td>
                                    <td>{$tbl['rows']}</td>
                                    <td><input type="checkbox" checked name="tables[]" value="{$tbl['name']}"></td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-6">Dont select logs if it failed</div>
                        <div class="col-md-4 text-right">
                            <button type="submit" class="btn btn-primary btn-xs btn-block"><i
                                    class="fa fa-download"></i>
                                {Lang::T('Download Database Backup')}</button>
                        </div>
                    </div>
                </div>
            </form>

        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <div class="">Restore Database</div>
            <form method="post" action="{$_url}settings/dbrestore" enctype="multipart/form-data">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-7"><input type="file" name="json" accept="application/json"></div>
                        <div class="col-md-5 text-right">
                            <button type="submit" class="btn btn-primary btn-block btn-xs"><i class="fa fa-upload"></i>
                                Restore Dabase</button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="panel-footer">Restoring database will clean up data and then restore all the data</div>
        </div>
    </div>
</div>

{include file="sections/footer.tpl"}