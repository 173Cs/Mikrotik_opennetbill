{include file="sections/header.tpl"}
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">


<div class="row">
	<div class="card">
		<div class="card-header">
			<div class="card-title">{Lang::T('Send Bulk Message')}</div>
			<div class="panel-body">
				<form class="form-horizontal" method="post" role="form" id="bulkMessageForm" action="">
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Group')}</label>
						<div class="col-md-6">
							<select class="form-control" name="group" id="group">
								<option value="all" selected>{Lang::T('All Customers')}</option>
								<option value="new">{Lang::T('New Customers')}</option>
								<option value="expired">{Lang::T('Expired Customers')}</option>
								<option value="active">{Lang::T('Active Customers')}</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Send Via')}</label>
						<div class="col-md-6">
							<select class="form-control" name="via" id="via">
								<option value="sms" selected>{Lang::T('SMS')}</option>
								<option value="wa">{Lang::T('WhatsApp')}</option>
								<option value="both">{Lang::T('SMS and WhatsApp')}</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">{Lang::T('Message')}</label>
						<div class="col-md-6">
							<textarea class="form-control" id="message" name="message"
								placeholder="{Lang::T('Compose your message...')}" rows="5"></textarea>
						</div>
						<p class="help-block col-md-4">
							{Lang::T('Use placeholders:')}
							<br>
							<b>[[name]]</b> - {Lang::T('Customer Name')}
							<br>
							<b>[[user_name]]</b> - {Lang::T('Customer Username')}
							<br>
							<b>[[phone]]</b> - {Lang::T('Customer Phone')}
							<br>
							<b>[[company_name]]</b> - {Lang::T('Your Company Name')}
						</p>
					</div>
					<div class="form-group">
						<div class="col-lg-offset-2 col-lg-10">
							<button class="btn btn-success" type="submit" name=send value=now>
								{Lang::T('Send Message')}</button>
							<a href="{$_url}dashboard" class="btn btn-default">{Lang::T('Cancel')}</a>
						</div>
					</div>
				</form>

			</div>
		</div>
	</div>
</div>

{if $batchStatus}
<p><span class="label label-success">Total SMS Sent: {$totalSMSSent}</span> <span class="label label-danger">Total SMS
		Failed: {$totalSMSFailed}</span> <span class="label label-success">Total WhatsApp Sent:
		{$totalWhatsappSent}</span> <span class="label label-danger">Total WhatsApp Failed:
		{$totalWhatsappFailed}</span></p>
{/if}
<div class="box">
	<div class="box-header">
		<h3 class="box-title">Message Results</h3>
	</div>
	<!-- /.box-header -->
	<div class="box-body">
		<table id="messageResultsTable" class="table table-bordered table-striped table-condensed">
			<thead>
				<tr>
					<th>Name</th>
					<th>Phone</th>
					<th>Message</th>
					<th>Status</th>
				</tr>
			</thead>
			<tbody>
				{foreach $batchStatus as $customer}
				<tr>
					<td>{$customer.name}</td>
					<td>{$customer.phone}</td>
					<td>{$customer.message}</td>
					<td>{$customer.status}</td>
				</tr>
				{/foreach}
			</tbody>
		</table>
	</div>
	<!-- /.box-body -->
</div>
<!-- /.box -->

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script>
	var $j = jQuery.noConflict();

	$j(document).ready(function () {
		$j('#messageResultsTable').DataTable();
	});
</script>




{include file="sections/footer.tpl"}