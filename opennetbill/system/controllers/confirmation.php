<?php

$action = $routes['1'];


if (file_exists($PAYMENTGATEWAY_PATH . DIRECTORY_SEPARATOR . $action . '.php')) {
    include $PAYMENTGATEWAY_PATH . DIRECTORY_SEPARATOR . $action . '.php';
    if (function_exists($action . '_offline_payment_confirmation')) {
        run_hook('offline_payment_confirmation'); #HOOK
        call_user_func($action . '_offline_payment_confirmation');
        die();
    }
}

header('HTTP/1.1 404 Not Found');
echo 'Not Found';