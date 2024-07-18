{include file="sections/header.tpl"}

<div class="row">
    <div class="card">
        <div class="card-header">
            <div class="card-title">{Lang::T('Refill Account')}</div>
            <div class="card-body">
                <form class="form-horizontal" method="post" role="form" action="{$_url}plan/refill-post">
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Select Account')}</label>
                        <div class="col-md-6">
                            <select id="personSelect" class="form-control select2" name="id_customer"
                                style="width: 100%" data-placeholder="{Lang::T('Select a customer')}...">
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Code Voucher')}</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="code" name="code"
                                placeholder="{Lang::T('Enter voucher code here')}">
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button class="btn btn-success"
                                type="submit">{Lang::T('Recharge')}</button>
                            Or <a href="{$_url}customers/list">{Lang::T('Cancel')}</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


{include file="sections/footer.tpl"}