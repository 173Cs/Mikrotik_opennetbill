<?php


_admin();
$ui->assign('_title', 'Support');
$ui->assign('_system_menu', 'support');

$action = $routes['1'];
$ui->assign('_admin', $admin);

$ui->display('support.tpl');