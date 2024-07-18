<?php


if(User::getID()){
    r2(U.'home');
}

if (isset($routes['1'])) {
    $do = $routes['1'];
} else {
    $do = 'login-display';
}

switch ($do) {
    case 'post':
        $username = _post('username');
        $password = _post('password');


        run_hook('customer_login'); // Hook execution

        $msg = ''; // Initialize an empty message variable to accumulate errors

        if ($username != '' && $password != '') {
            $d = ORM::for_table('tbl_customers')->where('username', $username)->find_one();
            if ($d) {
                $d_pass = $d['password'];
                if (Password::_uverify($password, $d_pass) == true) {
                    // Successful login
                    $_SESSION['uid'] = $d['id'];
                    User::setCookie($d['id']);
                    $d->last_login = date('Y-m-d H:i:s');
                    $d->save();
                    _log($username . ' ' . Lang::T('Login Successful'), 'User', $d['id']);
                    _alert(Lang::T('Login Successful'), 'success', "home");
                } else {
                    // Incorrect password
                    $msg .= Lang::T('Invalid Password') . '<br>'; 
                    _log($username . ' ' . Lang::T('Failed Login'), 'User');
                }
            } else {
                // Username not found
                $msg .= Lang::T('User does not exist') . '<br>'; 
               
            }
        } else {
            // Empty username or password
            $msg .= Lang::T('Enter username and password') . '<br>'; 
            r2(U . 'login', 'e', Lang::T('Voucher activation failed'));
        }
        
        $ui->assign('username', $username);
        $ui->assign('notify', $msg);
        $ui->assign('notify_t', 'd');
        $ui->display('user-login.tpl');
        break;
    case 'confirm':
        $trxid = $routes['2'];
        $checkstatus=$routes['3'];
        $trx = ORM::for_table('tbl_payment_gateway')
            ->where('id', $trxid)
            ->find_one();
        $user = ORM::for_table('tbl_customers')->where('username', $trx['username'])->find_one();    
        run_hook('customer_view_payment'); #HOOK
        // jika tidak ditemukan, berarti punya orang lain
        if (empty ($trx)) {
            r2(U . "order/package", 'w', Lang::T("Payment not found"));
        }
        // jika url kosong, balikin ke buy
        if (empty ($trx['pg_url_payment'])) {
            r2(U . "order/buy/" . (($trx['routers_id'] == 0) ? $trx['routers'] : $trx['routers_id']) . '/' . $trx['plan_id'], 'w', Lang::T("Checking payment"));
        }
        if ($checkstatus == 'check') {
            if (!file_exists($PAYMENTGATEWAY_PATH . DIRECTORY_SEPARATOR . $trx['gateway'] . '.php')) {
                r2(U . 'order/view/' . $trxid, 'e', Lang::T("No Payment Gateway Available"));
            }
            sleep(10);
            run_hook('customer_check_payment_status'); #HOOK
            include $PAYMENTGATEWAY_PATH . DIRECTORY_SEPARATOR . $trx['gateway'] . '.php';
            call_user_func($trx['gateway'] . '_validate_config');
            call_user_func( $trx['gateway'] . '_get_status', $trx, $user);
        } 
        else if ($routes['3'] == 'cancel') {
            run_hook('customer_cancel_payment'); #HOOK
            $trx->pg_paid_response = '{}';
            $trx->status = 4;
            $trx->paid_date = date('Y-m-d H:i:s');
            $trx->save();
            $trx = ORM::for_table('tbl_payment_gateway')
                ->where('id', $trxid)
                ->find_one();
        }
        if (empty ($trx)) {
            r2(U . "order/package", 'e', Lang::T("Transaction Not found"));
        }
        $router = Mikrotik::info($trx['routers']);
        $plan = ORM::for_table('tbl_plans')->find_one($trx['plan_id']);
        $bandw = ORM::for_table('tbl_bandwidth')->find_one($plan['id_bw']);
        list($bills, $add_cost) = User::getBills($user['id']);
        $instructions="<ol>
        <li>Please click confirm to check payment status</li>
        <li>Click Pay Now if payment was unsuccessful</li>
        </ol>";
        $ui->assign('trx', $trx);
        $ui->assign('router', $router);
        $ui->assign('plan', $plan);
        $ui->assign('bandw', $bandw);
        $ui->assign('instructions', $instructions);
        $ui->assign('_title', 'TRX #' . $trxid);
        $ui->display('no-login-orderView.tpl');
        break;    
    case 'activation':
        $voucher = _post('password');
        if($config['disable_registration'] == 'yes'){
            $v1 = ORM::for_table('tbl_payment_gateway')->where('gateway_trx_id', $voucher)->find_one();
            $user = ORM::for_table('tbl_customers')->where('username', $v1['username'])->find_one();
            $username=$user;
        }else{
            $voucher = _post('password');
            $username = _post('username');
        }

        if ($v1) {

            if (!$user) {
                r2(U . 'login', 'e', Lang::T('Reconnection failed, no user was found with that password') . '.');
            }
            if ($v1['gateway_trx_id']!= $user['password']) {
                r2(U . 'login', 'e', Lang::T('Reconnection failed, incorrect password') . '.');                
            } else {

                if ($v1['gateway_trx_id']== $user['password']) {
                    $user->last_login = date('Y-m-d H:i:s');
                    $user->save();
                    if (!empty($_SESSION['nux-mac']) && !empty($_SESSION['nux-ip'])) {
                        try {
                            $m = Mikrotik::info($v1['routers']);
                            $c = Mikrotik::getClient($m['ip_address'], $m['username'], $m['password']);
                            Mikrotik::logMeIn($c, $user['username'], $user['password'], $_SESSION['nux-ip'], $_SESSION['nux-mac']);
                            if (!empty($config['voucher_redirect'])) {
                                r2($config['voucher_redirect'], 's', Lang::T("Voucher activation success, you are connected to internet"));
                            } else {
                                r2(U . "login", 's', Lang::T("Reconnection success, now you are logged in"));
                            }
                        } catch (Exception $e) {
                            if (!empty($config['voucher_redirect'])) {
                                r2($config['voucher_redirect'], 's', Lang::T("Reconnection success, now you are logged in"));
                            } else {
                                r2(U . "login", 's', Lang::T("Reconnection success, now you are logged in"));
                            }
                        }
                    } else {
                        if (!empty($config['voucher_redirect'])) {
                            r2($config['voucher_redirect'], 's', Lang::T("Reconnection success, now you are logged in"));
                        } else {
                            r2(U . "login", 's', Lang::T("Reconnection success, now you are logged in"));
                        }
                    }
                } else {
                    // voucher used by other customer
                    r2(U . 'login', 'e', Lang::T('Code Entered Was Not Valid'));
                }
            }
        } else {
            _msglog('e', Lang::T('Invalid Username or Password'));
            r2(U . 'login', 'e', 'Incorrect Code Entered');
        }
    default:
        run_hook('customer_view_login'); #HOOK
        if ($config['disable_registration'] == 'yes') {
            $UPLOAD_URL_PATH = str_replace($root_path, '',  $UPLOAD_PATH);
            if (file_exists($UPLOAD_PATH . '/logo.png')) {
                $logo = $UPLOAD_URL_PATH . '/logo.png';
            } else {
                $logo = $UPLOAD_URL_PATH . '/logo.default.png';
            }

            if (file_exists($UPLOAD_PATH . '/background.jpeg')) {
                $background = $UPLOAD_URL_PATH . '/background.jpeg';
            } else {
                $background = $UPLOAD_URL_PATH . '/background.default.jpeg';
            }

            $instructions="<ol>
            <li>Choose package to subscribe below</li>
            <li>Enter M-pesa phone number & click subscribe</li>
            <li>Please wait patiently as system connects you to the internet</li>
            <li class='alert-danger' style='width:200px'>Customer care:0746126262</li>
            </ol>";
            $account_type = "Personal";
            $routers = ORM::for_table('tbl_routers')->find_many();
            $plans_hotspot = ORM::for_table('tbl_plans')->where('plan_type', $account_type)->where('enabled', '1')->where('is_radius', 0)->where('type', 'Hotspot')->where('prepaid', 'yes')->find_many();
            $ui->assign('logo',$logo);
            $ui->assign('background',$background);
            $ui->assign('routers',$routers);
            $ui->assign('plans_hotspot', $plans_hotspot);
            $ui->assign('instructions', $instructions);
            $ui->display('user-login-noreg.tpl');
        } else {
            $ui->display('user-login.tpl');
        }
        break;
}
