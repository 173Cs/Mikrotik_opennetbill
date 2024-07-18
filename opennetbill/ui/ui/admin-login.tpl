<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>{Lang::T('Login')} - {$_c['CompanyName']}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">


</head>
<style>
  @media (max-width: 767px) {
    .login-box{
        width:80%;
    }
           
        }
</style>

<body class="login-page" style="font-family: 'Poppins', sans-serif; background-color: #f4f4f4; padding-top: 10%;">

    <div class="login-box" style="width: 80%; max-width: 400px; margin: 0 auto; background-color: #fff; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 20px; position: absolute; top: 20%; left: 50%; transform: translateX(-50%);">

        <div class="login-logo" style="text-align: center; font-size: 24px; color: #333; margin-bottom: 20px;">
            {$_c['CompanyName']}
        </div>

        <div class="login-box-body">
            <p class="login-box-msg" style="text-align: center; color: #666; font-size: 18px; margin-bottom: 20px;">{Lang::T('Enter Admin Area')}</p>

            {if isset($notify)}
                <div class="alert alert-info" style="background-color: #d1ecf1; color: #0c5460; border-radius: 5px; padding: 10px; margin-bottom: 20px;">
                    {$notify}
                </div>
            {/if}

            <form action="{$_url}admin/post" method="post">
                <div class="form-group has-feedback" style="margin-bottom: 20px;">
                    <input type="text" required class="form-control" name="username" placeholder="{Lang::T('Username')}" style="border-radius: 5px; padding: 10px; border: 1px solid #ddd; width: 100%;">
                    <span class="glyphicon glyphicon-user form-control-feedback" style="color: #666;"></span>
                </div>

                <div class="form-group has-feedback" style="margin-bottom: 20px;">
                    <input type="password" required class="form-control" name="password" placeholder="{Lang::T('Password')}" style="border-radius: 5px; padding: 10px; border: 1px solid #ddd; width: 100%;">
                    <span class="glyphicon glyphicon-lock form-control-feedback" style="color: #666;"></span>
                </div>

                <button type="submit" class="btn btn-block btn-flat" style="background-color: #0d0c22; color: #fff; border-radius: 5px; padding: 10px; width: 100%;">{Lang::T('Login')}</button>
            </form>

        </div>

    </div>

</body>



</html>