{include file="sections/header.tpl"}

<br><br>

<div class="row">
    <div class="card">
        <div class="box box-hovered mb20 box-primary">
            <div class="box-header">
                <h3 class="box-title">Support</h3>
            </div>
            <div class="box-body">
                For any bug fix or additional features reach out to the Numbers below for assistance
            </div>
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <tbody>
                        <tr>
                            <td>Eli Musa</td>
                            <td>0100807734</td>
                        </tr>
                        <tr>
                            <td>David Mwaura</td>
                            <td>0716225112</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="box-footer">
                
            </div>
        </div>
    </div>
</div>
<script>
    window.addEventListener('DOMContentLoaded', function() {
        $.getJSON("./version.json?" + Math.random(), function(data) {
            $('#currentVersion').html('Current Version: ' + data.version);
        });
        $.getJSON("https://raw.githubusercontent.com/hotspotbilling/phpnuxbill/master/version.json?" + Math
            .random(),
            function(data) {
                $('#latestVersion').html('Latest Version: ' + data.version);
            });
    });
</script>
{include file="sections/footer.tpl"}