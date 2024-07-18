{include file="sections/header.tpl"}
 <style>
        ::-moz-selection {
            /* Code for Firefox */
            color: red;
            background: yellow;
        }

        ::selection {
            color: red;
            background: yellow;
        }

        // .content-wrapper {
        //     margin-top: 50px;
        // }

        @media (max-width: 767px) {
            .content-wrapper {
                margin-top: 100px;
            }
        }
        .logout{
            
        }


        .loading {
            pointer-events: none;
            opacity: 0.7;
        }
      
        .loading::after {
            content: "";
            display: inline-block;
            width: 16px;
            height: 16px;
            vertical-align: middle;
            margin-left: 10px;
            border: 2px solid #fff;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s infinite linear;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }
    </style>


<div class="hero-bg row">
    <div class=" card-1 col-lg-3 col-xs-6">
        <div class="small-box">
            <div class="metrix card1">
            <div class="inner">
                <p>{Lang::T('Income Today')}</p>
                <h1>{$_c['currency_code']} :
                    {number_format($iday,0,$_c['dec_point'],$_c['thousands_sep'])}</h1>
                </div>
            <a href="{$_url}reports/by-date" class="card-footer">{Lang::T('View Reports')} <i
                    class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
    </div>
    <div class=" card-1 col-lg-3 col-xs-6">
        <div class="small-box">
            <div class="metrix card2">
                <div class="inner">
                    <p>{Lang::T('Income This Month')}</p>
                    <h1>{$_c['currency_code']} :
                        {number_format($imonth,0,$_c['dec_point'],$_c['thousands_sep'])}</h1>
                </div>
                <a href="{$_url}reports/by-period" class="card-footer">{Lang::T('View Reports')} <i
                        class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
    </div>
    <div class=" card-1 col-lg-3 col-xs-6">
        <div class="small-box">
            <div class="metrix card3">
                <div class="inner">
                    <p>{Lang::T('Users Active')}</p>
                    <h1>{$u_act}/{$u_all}</h1>
                </div>
                <a href="{$_url}plan/list" class="card-footer">{Lang::T('View All')} <i
                        class="fa fa-arrow-circle-right"></i></a>
            </div>
        </div>
    </div>
    <div class=" card-1 col-lg-3 col-xs-6">
        <div class="small-box">
            <div class="metrix card4">
                <div class="inner">
                    <p>{Lang::T('Total Users')}</p>
                    <h1>{$c_all}</h1>
                </div>
                <a href="{$_url}customers/list" class="card-footer">{Lang::T('View All')} <i
                        class="fa fa-arrow-circle-right"></i></a>
        </div>
    </div>
</div>
<div class="row">
    <div class="sector col-md-7">
        {if $_c['hide_mrc'] != 'yes'}
            <div class="box box-solid ">
                <div class="box-header">
                    <h3 class=" trex box-title">{Lang::T('Monthly Registered Customers')}</h3>
                </div>
                <div class="box-body border-radius-none">
                    <canvas class="chart" id="chart" style="height: 250px;"></canvas>
                </div>
            </div>
        {/if}

       
        {if $_c['hide_tms'] != 'yes'}
            <div class="box box-solid ">
                <div class="box-header">
                    <h3 class="trex box-title">{Lang::T('Total Monthly Sales')}</h3>
                </div>
                <div class="box-body border-radius-none">
                    <canvas class="chart" id="salesChart" style="height: 250px;"></canvas>
                </div>
            </div>
        {/if}
        {if $_c['disable_voucher'] != 'yes' && $stocks['unused']>0 || $stocks['used']>0}
            {if $_c['hide_vs'] != 'yes'}
                <div class="panel panel-primary mb20 panel-hovered project-stats table-responsive">
                    <div class="panel-heading">Vouchers Stock</div>
                    <div class="table-responsive">
                        <table class="table table-condensed">
                            <thead>
                                <tr>
                                    <th>{Lang::T('Plan Name')}</th>
                                    <th>unused</th>
                                    <th>used</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $plans as $stok}
                                    <tr>
                                        <td>{$stok['name_plan']}</td>
                                        <td>{$stok['unused']}</td>
                                        <td>{$stok['used']}</td>
                                    </tr>
                                </tbody>
                            {/foreach}
                            <tr>
                                <td>Total</td>
                                <td>{$stocks['unused']}</td>
                                <td>{$stocks['used']}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            {/if}
        {/if}
        {if $_c['hide_uet'] != 'yes'}
            
        {/if}
    </div>


    <div class="col-md-5">
        {if $_c['hide_aui'] != 'yes'}
            <div class="panel panel-info panel-hovered mb20 activities">
                <h3 class="trex box-pie">{Lang::T('Total Monthly Sales')}</h3>
                <div class="panel-body">
                    <canvas id="userRechargesChart"></canvas>
                </div>
            </div>
        {/if}
       
    </div>


</div>


<script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>

<script type="text/javascript">
    {if $_c['hide_mrc'] != 'yes'}
        {literal}
            document.addEventListener("DOMContentLoaded", function() {
                var counts = JSON.parse('{/literal}{$monthlyRegistered|json_encode}{literal}');

                var monthNames = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ];

                var labels = [];
                var data = [];

                for (var i = 1; i <= 12; i++) {
                    var month = counts.find(count => count.date === i);
                    labels.push(month ? monthNames[i - 1] : monthNames[i - 1].substring(0, 3));
                    data.push(month ? month.count : 0);
                }

                var ctx = document.getElementById('chart').getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Registered Members',
                            data: data,
                            backgroundColor: 'rgba(94, 114, 228, 1)',
                            borderColor: 'rgba(255, 255, 255, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            x: {
                                grid: {
                                    display: false
                                }
                            },
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                }
                            }
                        }
                    }
                });
            });
        {/literal}
    {/if}
    {if $_c['hide_tmc'] != 'yes'}
        {literal}
            document.addEventListener("DOMContentLoaded", function() {
                var monthlySales = JSON.parse('{/literal}{$monthlySales|json_encode}{literal}');

                var monthNames = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ];

                var labels = [];
                var data = [];

                for (var i = 1; i <= 12; i++) {
                    var month = findMonthData(monthlySales, i);
                    labels.push(month ? monthNames[i - 1] : monthNames[i - 1].substring(0, 3));
                    data.push(month ? month.totalSales : 0);
                }

                var ctx = document.getElementById('salesChart').getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Monthly Sales',
                            data: data,
                            backgroundColor: 'rgba(13, 12, 34, 1)', // Customize the background color
                            borderColor: 'rgba(255, 255, 255, 1)', // Customize the border color
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            x: {
                                grid: {
                                    display: false
                                }
                            },
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                }
                            }
                        }
                    }
                });
            });

            function findMonthData(monthlySales, month) {
                for (var i = 0; i < monthlySales.length; i++) {
                    if (monthlySales[i].month === month) {
                        return monthlySales[i];
                    }
                }
                return null;
            }
        {/literal}
    {/if}
    {if $_c['hide_aui'] != 'yes'}
        {literal}
            document.addEventListener("DOMContentLoaded", function() {
                // Get the data from PHP and assign it to JavaScript variables
                var u_act = '{/literal}{$u_act}{literal}';
                var c_all = '{/literal}{$c_all}{literal}';
                var u_all = '{/literal}{$u_all}{literal}';
                //lets calculate the inactive users as reported
                var expired = u_all - u_act;
                var inactive = c_all - u_all;
                // Create the chart data
                var data = {
                    labels: ['Active Users', 'Expired Users', 'Inactive Users'],
                    datasets: [{
                        label: 'User Recharges',
                        data: [parseInt(u_act), parseInt(expired), parseInt(inactive)],
                        backgroundColor: ['rgba(13, 12, 34, 1)', 'rgba(255, 171, 231, 1)', 'rgba(210, 188, 243, 1'],
                        borderColor: ['rgba(255, 255, 255, 1)', 'rgba(255, 255, 255, 1)', 'rgba(255, 255, 255, 1'],
                        borderWidth: 1
                    }]
                };

                // Create chart options
                var options = {
                    responsive: true,
                    aspectRatio: 1,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 15
                            }
                        }
                    }
                };

                // Get the canvas element and create the chart
                var ctx = document.getElementById('userRechargesChart').getContext('2d');
                var chart = new Chart(ctx, {
                    type: 'pie',
                    data: data,
                    options: options
                });
            });
        {/literal}
    {/if}
</script>
<script>
    window.addEventListener('DOMContentLoaded', function() {
        $.getJSON("./version.json?" + Math.random(), function(data) {
            var localVersion = data.version;
            $('#version').html('Version: ' + localVersion);
            $.getJSON(
                "https://raw.githubusercontent.com/hotspotbilling/phpnuxbill/master/version.json?" +
                Math
                .random(),
                function(data) {
                    var latestVersion = data.version;
                    if (localVersion !== latestVersion) {
                        $('#version').html('Latest Version: ' + latestVersion);
                    }
                });
        });

    });
</script>

{include file="sections/footer.tpl"}