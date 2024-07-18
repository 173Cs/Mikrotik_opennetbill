<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>Error - Opennet</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />

    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">

    <link rel="stylesheet" href="ui/ui/fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="ui/ui/fonts/font-awesome/css/font-awesome.min.css">

    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">

    <style>
        ::-moz-selection {
            /* Code for Firefox */
            color: red;
            background: blue;
        }

        ::selection {
            color: white;
            background: blue;
        }
    </style>

</head>

<body class="hold-transition skin-blue">
    <div class="container">

        <section class="content">
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
                    <div class="box box-danger box-solid">
                        <section class="content-header">
                            <h1 class="text-center">
                                {$error_title}
                            </h1>
                        </section>
                        <div class="box-body" style="font-size: larger;">
                            <center>
                            <br>
                            {$error_message}
                            <br>
                            Mikrotik troubleshooting: <br>
                        </div>
                       
                    </div>
                </div>
            </div>
        </section>
    </div>
</body>

</html>