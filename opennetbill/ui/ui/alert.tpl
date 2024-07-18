<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{ucwords(Lang::T($type))} - {$_c['CompanyName']}</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />
    <link rel="stylesheet" href="ui/ui/styles/bootstrap.min.css">
    <link rel="stylesheet" href="ui/ui/styles/modern-AdminLTE.min.css">
    <meta http-equiv="refresh" content="{$time}; url={$url}">
</head>
<style>
.loading-spinner {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.spinner {
    border: 4px solid #0d0c22;
    border-top: 4px solid transparent;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.spinner-text {
    font-family: 'Poppins', sans-serif;
    color: #0d0c22;
    font-size: 20px;
    margin-top: 10px;
}
</style>

<body class="hold-transition lockscreen">
    <div class="lockscreen-wrapper">
        <div class="loading-spinner">
            <div class="spinner"></div>
           
        </div>
    </div>

    <script>
        // Simulate loading time
        var time = 5; // You can adjust the time here
        timer();

        function timer() {
            setTimeout(() => {
                time--;
                if (time > -1) {
                    document.querySelector('.spinner-text').innerHTML = "Loading...(" + time + ")";
                    timer();
                }
            }, 1000);
        }
    </script>
</body>


</html>