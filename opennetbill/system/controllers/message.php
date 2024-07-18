<?php

require 'vendor/autoload.php';
use AfricasTalking\SDK\AfricasTalking;

_admin();
$ui->assign('_title', Lang::T('Send Message'));
$ui->assign('_system_menu', 'message');

$action = $routes['1'];
$ui->assign('_admin', $admin);

if (empty($action)) {
    $action = 'send';
}

switch ($action) {
    case 'send':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }

        $select2_customer = <<<EOT
<script>
document.addEventListener("DOMContentLoaded", function(event) {
    $('#personSelect').select2({
        theme: "bootstrap",
        ajax: {
            url: function(params) {
                if(params.term != undefined){
                    return './index.php?_route=autoload/customer_select2&s='+params.term;
                }else{
                    return './index.php?_route=autoload/customer_select2';
                }
            }
        }
    });
});
</script>
EOT;
        if (isset($routes['2']) && !empty($routes['2'])) {
            $ui->assign('cust', ORM::for_table('tbl_customers')->find_one($routes['2']));
        }
        $id = $routes['2'];
        $ui->assign('id', $id);
        $ui->assign('xfooter', $select2_customer);
        $ui->display('message.tpl');
        break;

    case 'send-post':
        // Check user permissions
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }

        // Get form data
        $id_customer = $_POST['id_customer'];
        $message = $_POST['message'];
        $via = $_POST['via'];

        // Check if fields are empty
        if ($id_customer == '' or $message == '' or $via == '') {
            r2(U . 'message/send', 'e', Lang::T('All field is required'));
        } else {
            // Get customer details from the database
            $c = ORM::for_table('tbl_customers')->find_one($id_customer);

            // Replace placeholders in the message with actual values
            $message = str_replace('[[name]]', $c['fullname'], $message);
            $message = str_replace('[[user_name]]', $c['username'], $message);
            $message = str_replace('[[phone]]', $c['phonenumber'], $message);
            $message = str_replace('[[company_name]]', $config['CompanyName'], $message);


            //Send the message
            if ($via == 'sms' || $via == 'both') {
                $smsSent = Message::sendSMS($c['phonenumber'], $message);
            }

            if ($via == 'wa' || $via == 'both') {
                $waSent = Message::sendWhatsapp($c['phonenumber'], $message);
            }

            if (isset($smsSent) || isset($waSent)) {
                r2(U . 'message/send', 's', Lang::T('Message Sent Successfully'));
            } else {
                r2(U . 'message/send', 'e', Lang::T('Failed to send message'));
            }
        }
        break;

    case 'send_bulk':
        
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");

        }

        // Get form data
        $group = $_POST['group'];
        $message = $_POST['message'];
        $via = $_POST['via'];
       

        // Initialize counters
        $totalSMSSent = 0;
        $totalSMSFailed = 0;
        $totalWhatsappSent = 0;
        $totalWhatsappFailed = 0;
        $batchStatus = [];

        if (_req('send') == 'now') {
            // Check if fields are empty
            if ($group == '' || $message == '' || $via == '') {
                r2(U . 'message/send_bulk', 'e', Lang::T('All fields are required'));
            } else {
                // Get customer details from the database based on the selected group
                if ($group == 'all') {
                    $customers = ORM::for_table('tbl_customers')->find_many()->as_array();
                } elseif ($group == 'new') {
                    // Get customers created just a month ago
                    $customers = ORM::for_table('tbl_customers')->where_raw("DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)")->find_many()->as_array();
                } elseif ($group == 'expired') {
                    // Get expired user recharges where status is 'off'
                    $expired = ORM::for_table('tbl_user_recharges')->where('status', 'off')->find_many();
                    $customer_ids = [];
                    foreach ($expired as $recharge) {
                        $customer_ids[] = $recharge->customer_id;
                    }
                    $customers = ORM::for_table('tbl_customers')->where_in('id', $customer_ids)->find_many()->as_array();
                } elseif ($group == 'active') {
                    // Get active user recharges where status is 'on'
                    $active = ORM::for_table('tbl_user_recharges')->where('status', 'on')->find_many();
                    $customer_ids = [];
                    foreach ($active as $recharge) {
                        $customer_ids[] = $recharge->customer_id;
                    }
                    $customers = ORM::for_table('tbl_customers')->where_in('id', $customer_ids)->find_many()->as_array();
                }

                // Set the batch size
                $batchSize = $batch;

                //african talking api
                    $username = $config['appName'];; // Use 'sandbox' for development in the test environment
                    $apiKey   = $config['apiKey'];  // Use your sandbox app API key for development in the test environment

                    // Initialize the SDK
                    $AT       = new AfricasTalking($username, $apiKey);

                    // Get the SMS service
                    $sms      = $AT->sms();

                    // Function to send SMS via Africa's Talking API
                    function sendBulkSMS($recipients, $message) {
                        global $sms;
                        try {
                            $result = $sms->send([
                                'to'      => $recipients,
                                'message' => $message
                            ]);
                            if ($result['status'] == 'success') {
                                r2(U . 'message/send_bulk', 's', Lang::T('The message send succesfully'));
                            }else{
                                r2(U . 'message/send_bulk', 'e', Lang::T('Message was not sent'));
                            }
                        } catch (Exception $e) {
                            r2(U . 'message/send_bulk', 'e', Lang::T('Something went wrong'));
                        }
                    }
                  $recipients = [];
                foreach ($customers as $c) {
                    // Replace placeholders in the message with actual values
                    $personalizedMessage = str_replace('[[name]]', $c['fullname'], $message);
                    $personalizedMessage = str_replace('[[user_name]]', $c['username'], $personalizedMessage);
                    $personalizedMessage = str_replace('[[phone]]', $c['phonenumber'], $personalizedMessage);
                    $personalizedMessage = str_replace('[[company_name]]', $config['CompanyName'], $personalizedMessage);

                    // Add the phone number and message to the recipients list
                    $recipients[] = $c['phonenumber'];
                }
                $phones = implode(',', $recipients);
                
                if ($via == 'sms' || $via == 'both') {
                    sendBulkSMS($phones, $message);
                    }
                
            }
        }
        $ui->assign('batchStatus', $batchStatus);
        $ui->assign('totalSMSSent', $totalSMSSent);
        $ui->assign('totalSMSFailed', $totalSMSFailed);
        $ui->assign('totalWhatsappSent', $totalWhatsappSent);
        $ui->assign('totalWhatsappFailed', $totalWhatsappFailed);
        $ui->display('message-bulk.tpl');
        break;

    default:
        r2(U . 'dashboard', 'e', 'action not defined');
}
