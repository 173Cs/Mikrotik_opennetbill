<?php

/**
 *  PHP Mikrotik Billing (https://github.com/hotspotbilling/phpnuxbill/)
 *  by https://t.me/ibnux
 **/

use PEAR2\Net\RouterOS;
_admin();
$ui->assign('_title', Lang::T('Customer'));
$ui->assign('_system_menu', 'customers');

$action = $routes['1'];
$ui->assign('_admin', $admin);

if (empty ($action)) {
    $action = 'list';
}

$leafletpickerHeader = <<<EOT
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
EOT;

switch ($action) {
    case 'list':
        $search = _post('search');
        run_hook('list_customers'); #HOOK
        if ($search != '') {
            $paginator = Paginator::build(ORM::for_table('tbl_customers'), [
                'username' => '%' . $search . '%',
                'fullname' => '%' . $search . '%',
                'phonenumber' => '%' . $search . '%',
                'email' => '%' . $search . '%',
                'service_type' => '%' . $search . '%'
            ], $search);
            $d = ORM::for_table('tbl_customers')
                ->where_raw("(`username` LIKE '%$search%' OR `fullname` LIKE '%$search%' OR `phonenumber` LIKE '%$search%' OR `email` LIKE '%$search%')")
                ->offset($paginator['startpoint'])
                ->limit($paginator['limit'])
                ->order_by_asc('username')
                ->find_many();
        } else {
            $paginator = Paginator::build(ORM::for_table('tbl_customers'));
            $d = ORM::for_table('tbl_customers')
                ->offset($paginator['startpoint'])->limit($paginator['limit'])->order_by_desc('id')->find_many();
        }

        $ui->assign('search', htmlspecialchars($search));
        $ui->assign('d', $d);
        $ui->assign('paginator', $paginator);
        $ui->display('customers.tpl');
        break;

    case 'csv':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $cs = ORM::for_table('tbl_customers')
            ->select('tbl_customers.id', 'id')
            ->select('tbl_customers.username', 'username')
            ->select('fullname')
            ->select('phonenumber')
            ->select('email')
            ->select('balance')
            ->select('namebp')
            ->select('routers')
            ->select('status')
            ->select('method', 'Payment')
            ->join('tbl_user_recharges', array('tbl_customers.id', '=', 'tbl_user_recharges.customer_id'))
            ->order_by_asc('tbl_customers.id')->find_array();
        $h = false;
        set_time_limit(-1);
        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header("Content-type: text/csv");
        header('Content-Disposition: attachment;filename="phpnuxbill_customers_' . date('Y-m-d_H_i') . '.csv"');
        header('Content-Transfer-Encoding: binary');
        foreach ($cs as $c) {
            $ks = [];
            $vs = [];
            foreach ($c as $k => $v) {
                $ks[] = $k;
                $vs[] = $v;
            }
            if (!$h) {
                echo '"' . implode('";"', $ks) . "\"\n";
                $h = true;
            }
            echo '"' . implode('";"', $vs) . "\"\n";
        }
        break;
    case 'add':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }

        $r = ORM::for_table('tbl_routers')->find_many();
        $ui->assign('r', $r);
        $ui->assign('xheader', $leafletpickerHeader);
        run_hook('view_add_customer'); #HOOK
        $ui->display('customers-add.tpl');
        break;
    case 'recharge':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent', 'Sales'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id_customer = $routes['2'];
        $plan_id = $routes['3'];
        $b = ORM::for_table('tbl_user_recharges')->where('customer_id', $id_customer)->where('plan_id', $plan_id)->find_one();
        if ($b) {
            $gateway = 'Recharge';
            $channel = $admin['fullname'];
            $cust = User::_info($id_customer);
            $plan = ORM::for_table('tbl_plans')->find_one($b['plan_id']);
            list($bills, $add_cost) = User::getBills($id_customer);
            if ($using == 'balance' && $config['enable_balance'] == 'yes') {
                if (!$cust) {
                    r2(U . 'plan/recharge', 'e', Lang::T('Customer not found'));
                }
                if (!$plan) {
                    r2(U . 'plan/recharge', 'e', Lang::T('Plan not found'));
                }
                if ($cust['balance'] < ($plan['price'] + $add_cost)) {
                    r2(U . 'plan/recharge', 'e', Lang::T('insufficient balance'));
                }
                $gateway = 'Recharge Balance';
            }
            if ($using == 'zero') {
                $zero = 1;
                $gateway = 'Recharge Zero';
            }
            $ui->assign('bills', $bills);
            $ui->assign('add_cost', $add_cost);
            $ui->assign('cust', $cust);
            $ui->assign('gateway', $gateway);
            $ui->assign('channel', $channel);
            $ui->assign('server', $b['routers']);
            $ui->assign('using', 'cash');
            $ui->assign('plan', $plan);
            $ui->display('recharge-confirm.tpl');
        } else {
            r2(U . 'customers/view/' . $id_customer, 'e', 'Cannot find active plan');
        }
        break;
    case 'deactivate':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id_customer = $routes['2'];
        $plan_id = $routes['3'];
        $b = ORM::for_table('tbl_user_recharges')->where('customer_id', $id_customer)->where('plan_id', $plan_id)->find_one();
        if ($b) {
            $p = ORM::for_table('tbl_plans')->where('id', $b['plan_id'])->find_one();
            if ($p) {
                if ($p['is_radius']) {
                    Radius::customerDeactivate($b['username']);
                } else {
                    $mikrotik = Mikrotik::info($b['routers']);
                    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                    if ($b['type'] == 'Hotspot') {
                        Mikrotik::removeHotspotUser($client, $b['username']);
                        Mikrotik::removeHotspotActiveUser($client, $b['username']);
                    } else if ($b['type'] == 'PPPOE') {
                        Mikrotik::removePpoeUser($client, $b['username']);
                        Mikrotik::removePpoeActive($client, $b['username']);
                    }
                }
                $b->status = 'off';
                $b->expiration = date('Y-m-d');
                $b->time = date('H:i:s');
                $b->save();
                _log('Admin ' . $admin['username'] . ' Deactivate ' . $b['namebp'] . ' for ' . $b['username'], 'User', $b['customer_id']);
                Message::sendTelegram('Admin ' . $admin['username'] . ' Deactivate ' . $b['namebp'] . ' for u' . $b['username']);
                r2(U . 'customers/view/' . $id_customer, 's', 'Success deactivate customer to Mikrotik');
            }
        }
        r2(U . 'customers/view/' . $id_customer, 'e', 'Cannot find active plan');
        break;
    case 'sync':
        $id_customer = $routes['2'];
        $bs = ORM::for_table('tbl_user_recharges')->where('customer_id', $id_customer)->where('status', 'on')->findMany();
        if ($bs) {
            $routers = [];
            foreach ($bs as $b) {
                $c = ORM::for_table('tbl_customers')->find_one($id_customer);
                $p = ORM::for_table('tbl_plans')->where('id', $b['plan_id'])->where('enabled', '1')->find_one();
                if ($p) {
                    $routers[] = $b['routers'];
                    if ($p['is_radius']) {
                        Radius::customerAddPlan($c, $p, $p['expiration'] . ' ' . $p['time']);
                    } else {
                        $mikrotik = Mikrotik::info($b['routers']);
                        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                        if ($b['type'] == 'Hotspot') {
                            Mikrotik::addHotspotUser($client, $p, $c);
                        } else if ($b['type'] == 'PPPOE') {
                            Mikrotik::addPpoeUser($client, $p, $c);
                        }
                    }
                }
            }
            r2(U . 'customers/view/' . $id_customer, 's', 'Sync success to ' . implode(", ", $routers));
        }
        r2(U . 'customers/view/' . $id_customer, 'e', 'Cannot find active plan');
        break;
    case 'view':
        $customer = ORM::for_table('tbl_customers')->where('username', $routes['2'])->find_one();
    case 'view':
        $id = $routes['2'];
        run_hook('view_customer'); #HOOK
        if (!$customer) {
            $customer = ORM::for_table('tbl_customers')->find_one($id);
        }
        if ($customer) {


            // Fetch the Customers Attributes values from the tbl_customer_custom_fields table
            $customFields = ORM::for_table('tbl_customers_fields')
                ->where('customer_id', $customer['id'])
                ->find_many();
            $v = $routes['3'];
            if (empty ($v)) {
                $v = 'activation';
            }
            if ($v == 'order') {
                $v = 'order';
                $paginator = Paginator::build(ORM::for_table('tbl_payment_gateway'), ['username' => $customer['username']]);
                $order = ORM::for_table('tbl_payment_gateway')
                    ->where('username', $customer['username'])
                    ->offset($paginator['startpoint'])
                    ->limit($paginator['limit'])
                    ->order_by_desc('id')
                    ->find_many();
                $ui->assign('paginator', $paginator);
                $ui->assign('order', $order);
            } else if ($v == 'activation') {
                $paginator = Paginator::build(ORM::for_table('tbl_transactions'), ['username' => $customer['username']]);
                $activation = ORM::for_table('tbl_transactions')
                    ->where('username', $customer['username'])
                    ->offset($paginator['startpoint'])
                    ->limit($paginator['limit'])
                    ->order_by_desc('id')
                    ->find_many();
                $ui->assign('paginator', $paginator);
                $ui->assign('activation', $activation);
            } else if ($v == 'session') {
                $transaction =ORM::for_table('tbl_transactions')->where('username',$customer['username']);
                $router = $transaction['routers'];
                $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
                $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

                function mikrotik_formatBytes($bytes, $precision = 2)
                {
                   $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
                   $bytes = max($bytes, 0);
                   $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
                   $pow = min($pow, count($units) - 1);
                   $bytes /= pow(1024, $pow);
                   return round($bytes, $precision) . ' ' . $units[$pow];
                }

                if($transaction['type']=="Hotspot"){
                    $hotspotActive = $client->sendSync(new RouterOS\Request('/ip/hotspot/active/print'));
            
                    $hotspotList = [];
                    foreach ($hotspotActive as $hotspot) {
                        $username = $hotspot->getProperty('user');
    
                        if ($username == $customer['username']) {
                            $address = $hotspot->getProperty('address');
                            $uptime = $hotspot->getProperty('uptime');
                            $server = $hotspot->getProperty('server');
                            $mac = $hotspot->getProperty('mac-address');
                            $sessionTime = $hotspot->getProperty('session-time-left');
                            $rxBytes = $hotspot->getProperty('bytes-in');
                            $txBytes = $hotspot->getProperty('bytes-out');
            
                            $hotspotList[] = [
                                'username' => $username,
                                'address' => $address,
                                'uptime' => $uptime,
                                'server' => $server,
                                'mac' => $mac,
                                'session_time' => $sessionTime,
                                'rx_bytes' => mikrotik_formatBytes($rxBytes),
                                'tx_bytes' => mikrotik_formatBytes($txBytes),
                                'total' => mikrotik_formatBytes($txBytes + $rxBytes),
                            ];
                        }
                    }
                    $ui->assign('session_type',$transaction['type']);
                    $ui->assign('session', $hotspotList);
                    
                }else{
                    $pppUsers = $client->sendSync(new RouterOS\Request('/ppp/active/print'));
                    $userList = [];
                    foreach ($pppUsers as $pppUser) {
                        $username = $pppUser->getProperty('name');
                        if ($username == $customer['username']) {
                        $address = $pppUser->getProperty('address');
                        $uptime = $pppUser->getProperty('uptime');
                        $service = $pppUser->getProperty('service');
                        $callerid = $pppUser->getProperty('caller-id');
                        $bytes_in = $pppUser->getProperty('limit-bytes-in');
                        $bytes_out = $pppUser->getProperty('limit-bytes-out');
                
                        $hotspotList[] = [
                            'username' => $username,
                            'address' => $address,
                            'uptime' => $uptime,
                            'service' => $service,
                            'caller_id' => $callerid,
                            'bytes_in' => $bytes_in,
                            'bytes_out' => $bytes_out,
                        ];
                        }
                    }
                    $ui->assign('session_type',$transaction['type']);
                    $ui->assign('session', $hotspotList);
                }
            }
            $ui->assign('packages', User::_billing($customer['id']));
            $ui->assign('v', $v);
            $ui->assign('d', $customer);
            $ui->assign('customFields', $customFields);
            $ui->display('customers-view.tpl');
        } else {
            r2(U . 'customers/list', 'e', $_L['Account_Not_Found']);
        }
        break;
    case 'edit':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Agent'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id = $routes['2'];
        run_hook('edit_customer'); #HOOK
        $d = ORM::for_table('tbl_customers')->find_one($id);
        // Fetch the Customers Attributes values from the tbl_customers_fields table
        $customFields = ORM::for_table('tbl_customers_fields')
            ->where('customer_id', $id)
            ->find_many();
        if ($d) {
            $ui->assign('d', $d);
            $ui->assign('customFields', $customFields);
            $ui->assign('xheader', $leafletpickerHeader);
            $ui->display('customers-edit.tpl');
        } else {
            r2(U . 'customers/list', 'e', $_L['Account_Not_Found']);
        }
        break;

    case 'delete':
        if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
            _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        }
        $id = $routes['2'];
        run_hook('delete_customer'); #HOOK
        $d = ORM::for_table('tbl_customers')->find_one($id);
        if ($d) {
            // Delete the associated Customers Attributes records from tbl_customer_custom_fields table
            ORM::for_table('tbl_customers_fields')->where('customer_id', $id)->delete_many();
            $c = ORM::for_table('tbl_user_recharges')->where('username', $d['username'])->find_one();
            if ($c) {
                $p = ORM::for_table('tbl_plans')->find_one($c['plan_id']);
                if ($p['is_radius']) {
                    Radius::customerDelete($d['username']);
                } else {
                    $mikrotik = Mikrotik::info($c['routers']);
                    if ($c['type'] == 'Hotspot') {
                        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                        Mikrotik::removeHotspotUser($client, $d['username']);
                        Mikrotik::removeHotspotActiveUser($client, $d['username']);
                    } else {
                        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                        Mikrotik::removePpoeUser($client, $d['username']);
                        Mikrotik::removePpoeActive($client, $d['username']);
                    }
                    try {
                        $d->delete();
                    } catch (Exception $e) {
                    } catch (Throwable $e) {
                    }
                    try {
                        $c->delete();
                    } catch (Exception $e) {
                    }
                }
            } else {
                try {
                    $d->delete();
                } catch (Exception $e) {
                } catch (Throwable $e) {
                }
                try {
                    if ($c)
                        $c->delete();
                } catch (Exception $e) {
                } catch (Throwable $e) {
                }
            }

            r2(U . 'customers/list', 's', Lang::T('User deleted Successfully'));
        }
        break;

    case 'add-post':
        global $config;

        $username = _post('username');
        $fullname = _post('fullname');
        $password = _post('password');
        $pppoe_password = _post('pppoe_password');
        $email = _post('email');
        $address = _post('address');
        $phonenumber = _post('phonenumber');
        $service_type = _post('service_type');
        $account_type = _post('account_type');
        $coordinates = _post('coordinates');
        $routers = _post('routers');
        //post Customers Attributes
        $custom_field_names = (array) $_POST['custom_field_name'];
        $custom_field_values = (array) $_POST['custom_field_value'];

        run_hook('add_customer'); #HOOK
        $msg = '';
        if (Validator::Length($username, 35, 2) == false) {
            $msg .= 'Username should be between 3 to 55 characters' . '<br>';
        }
        if (Validator::Length($fullname, 36, 2) == false) {
            $msg .= 'Full Name should be between 3 to 25 characters' . '<br>';
        }
        if (!Validator::Length($password, 36, 2)) {
            $msg .= 'Password should be between 3 to 35 characters' . '<br>';
        }

        if ($msg == '') {
            $d = ORM::for_table('tbl_customers')->create();
            $d->username = Lang::phoneFormat($username);
            $d->password = $password;
            $d->pppoe_password = $pppoe_password;
            $d->email = $email;
            $d->account_type = $account_type;
            $d->fullname = $fullname;
            $d->address =sprintf("%06d",mt_rand(1,999999));
            $d->created_by = $admin['id'];
            $d->phonenumber = Lang::phoneFormat($phonenumber);
            $d->service_type = $service_type;
            $d->coordinates = $coordinates;
            $d->save();
            $customer=$d;
            // Retrieve the customer ID of the newly created customer
            $customerId = $d->id();
            $text=$d->$config['CompanyName'] . "\n For paybill payments your account number is:".$d->address;

            Message::sendTelegram($text);
            Message::sendSMS($d->phonenumber, $config['CompanyName'] . "\n For paybill payments your account number is: $d->address");
            
            $mikrotik = Mikrotik::info($routers);
            $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
            $plan=[];
            if ($d['service_type'] == 'Hotspot') {
                Mikrotik::addHotspotUser($client, $plan,$customer);
            } else if ($d['service_type'] == 'PPPoE') {
                Mikrotik::setPpoeUser($client, $d['username'], $d['$pppoe_password']);
            }
            // Save Customers Attributes details
            if (!empty ($custom_field_names) && !empty ($custom_field_values)) {
                $totalFields = min(count($custom_field_names), count($custom_field_values));
                for ($i = 0; $i < $totalFields; $i++) {
                    $name = $custom_field_names[$i];
                    $value = $custom_field_values[$i];

                    if (!empty ($name)) {
                        $customField = ORM::for_table('tbl_customers_fields')->create();
                        $customField->customer_id = $customerId;
                        $customField->field_name = $name;
                        $customField->field_value = $value;
                        $customField->save();
                    }
                }
            }


            r2(U . 'customers/list', 's', Lang::T('Account Created Successfully'. $d['service_type']));
        } else {
            r2(U . 'customers/add', 'e', $msg);
        }
        break;

    case 'edit-post':
        $username = Lang::phoneFormat(_post('username'));
        $fullname = _post('fullname');
        $account_type = _post('account_type');
        $password = _post('password');
        $pppoe_password = _post('pppoe_password');
        $email = _post('email');
        $address = _post('address');
        $phonenumber = Lang::phoneFormat(_post('phonenumber'));
        $service_type = _post('service_type');
        $coordinates = _post('coordinates');
        run_hook('edit_customer'); #HOOK
        $msg = '';
        if (Validator::Length($username, 35, 2) == false) {
            $msg .= 'Username should be between 3 to 15 characters' . '<br>';
        }
        if (Validator::Length($fullname, 36, 1) == false) {
            $msg .= 'Full Name should be between 2 to 25 characters' . '<br>';
        }
        if ($password != '') {
            if (!Validator::Length($password, 36, 2)) {
                $msg .= 'Password should be between 3 to 15 characters' . '<br>';
            }
        }

        $id = _post('id');
        $d = ORM::for_table('tbl_customers')->find_one($id);

        //lets find user Customers Attributes using id
        $customFields = ORM::for_table('tbl_customers_fields')
            ->where('customer_id', $id)
            ->find_many();

        if (!$d) {
            $msg .= Lang::T('Data Not Found') . '<br>';
        }

        $oldusername = $d['username'];
        $oldPppoePassword = $d['password'];
        $oldPassPassword = $d['pppoe_password'];
        $userDiff = false;
        $pppoeDiff = false;
        $passDiff = false;
        if ($oldusername != $username) {
            $c = ORM::for_table('tbl_customers')->where('username', $username)->find_one();
            if ($c) {
                $msg .= Lang::T('Account already exist') . '<br>';
            }
            $userDiff = true;
        }
        if ($oldPppoePassword != $pppoe_password) {
            $pppoeDiff = true;
        }
        if ($password != '' && $oldPassPassword != $password) {
            $passDiff = true;
        }

        if ($msg == '') {
            if ($userDiff) {
                $d->username = $username;
            }
            if ($password != '') {
                $d->password = $password;
            }
            $d->pppoe_password = $pppoe_password;
            $d->fullname = $fullname;
            $d->email = $email;
            $d->account_type = $account_type;
            $d->address = $address;
            $d->phonenumber = $phonenumber;
            $d->service_type = $service_type;
            $d->coordinates = $coordinates;
            $d->save();

            $text=$d->$config['CompanyName'] . "\n For paybill payments your account number is:".$d->address;
            Message::sendTelegram($text);
            Message::sendSMS($d->phonenumber, $config['CompanyName'] . "\n For paybill payments your account number is: $d->address");

            // Update Customers Attributes values in tbl_customers_fields table
            foreach ($customFields as $customField) {
                $fieldName = $customField['field_name'];
                if (isset ($_POST['custom_fields'][$fieldName])) {
                    $customFieldValue = $_POST['custom_fields'][$fieldName];
                    $customField->set('field_value', $customFieldValue);
                    $customField->save();
                }
            }

            // Add new Customers Attributess
            if (isset ($_POST['custom_field_name']) && isset ($_POST['custom_field_value'])) {
                $newCustomFieldNames = $_POST['custom_field_name'];
                $newCustomFieldValues = $_POST['custom_field_value'];

                // Check if the number of field names and values match
                if (count($newCustomFieldNames) == count($newCustomFieldValues)) {
                    $numNewFields = count($newCustomFieldNames);

                    for ($i = 0; $i < $numNewFields; $i++) {
                        $fieldName = $newCustomFieldNames[$i];
                        $fieldValue = $newCustomFieldValues[$i];

                        // Insert the new Customers Attributes
                        $newCustomField = ORM::for_table('tbl_customers_fields')->create();
                        $newCustomField->set('customer_id', $id);
                        $newCustomField->set('field_name', $fieldName);
                        $newCustomField->set('field_value', $fieldValue);
                        $newCustomField->save();
                    }
                }
            }

            // Delete Customers Attributess
            if (isset ($_POST['delete_custom_fields'])) {
                $fieldsToDelete = $_POST['delete_custom_fields'];
                foreach ($fieldsToDelete as $fieldName) {
                    // Delete the Customers Attributes with the given field name
                    ORM::for_table('tbl_customers_fields')
                        ->where('field_name', $fieldName)
                        ->where('customer_id', $id)
                        ->delete_many();
                }
            }

            if ($userDiff || $pppoeDiff || $passDiff) {
                $c = ORM::for_table('tbl_user_recharges')->where('username', ($userDiff) ? $oldusername : $username)->find_one();
                if ($c) {
                    $c->username = $username;
                    $c->save();
                    $p = ORM::for_table('tbl_plans')->find_one($c['plan_id']);
                    if ($p['is_radius']) {
                        if ($userDiff) {
                            Radius::customerChangeUsername($oldusername, $username);
                        }
                        Radius::customerAddPlan($d, $p, $p['expiration'] . ' ' . $p['time']);
                    } else {
                        $mikrotik = Mikrotik::info($c['routers']);
                        if ($c['type'] == 'Hotspot') {
                            $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                            Mikrotik::setHotspotUser($client, $c['username'], $password);
                            Mikrotik::removeHotspotActiveUser($client, $d['username']);
                        } else {
                            $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                            if (!empty ($d['pppoe_password'])) {
                                Mikrotik::setPpoeUser($client, $c['username'], $d['pppoe_password']);
                            } else {
                                Mikrotik::setPpoeUser($client, $c['username'], $password);
                            }
                            Mikrotik::removePpoeActive($client, $d['username']);
                        }
                    }
                }
            }
            r2(U . 'customers/view/' . $id, 's', 'User Updated Successfully');
        } else {
            r2(U . 'customers/edit/' . $id, 'e', $msg);
        }
        break;

    default:
        r2(U . 'customers/list', 'e', 'action not defined');
}
