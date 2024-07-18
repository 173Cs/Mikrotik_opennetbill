{include file="sections/header.tpl"}

<form class="form-horizontal" method="post" role="form" action="{$_url}customers/add-post">
    <div class="row">
        <div class="card">
            <div class="card-header">
                <div class="panel-heading">{Lang::T('Add New Contact')}</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Username')}</label>
                        <div class="col-md-9">
                            <div class="input-group">
                                {if $_c['country_code_phone']!= ''}
                                    <span class="input-group-addon" id="basic-addon1">+</span>
                                {else}
                                    <span class="input-group-addon" id="basic-addon1"><i
                                            class="glyphicon glyphicon-phone-alt"></i></span>
                                {/if}
                                <input type="text" class="form-control" name="username" required
                                    placeholder="{if $_c['country_code_phone']!= ''}{$_c['country_code_phone']}{/if} {Lang::T('Phone Number')}">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Full Name')}</label>
                        <div class="col-md-9">
                            <input type="text" required class="form-control" id="fullname" name="fullname">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Email')}</label>
                        <div class="col-md-9">
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Phone Number')}</label>
                        <div class="col-md-9">
                            <div class="input-group">
                                {if $_c['country_code_phone']!= ''}
                                    <span class="input-group-addon" id="basic-addon1">+</span>
                                {else}
                                    <span class="input-group-addon" id="basic-addon1"><i
                                            class="glyphicon glyphicon-phone-alt"></i></span>
                                {/if}
                                <input type="text" class="form-control" name="phonenumber"
                                    placeholder="{if $_c['country_code_phone']!= ''}{$_c['country_code_phone']}{/if} {Lang::T('Phone Number')}">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Password')}</label>
                        <div class="col-md-9">
                            <input type="password" class="form-control" autocomplete="off" required id="password"
                                value="{rand(000000,999999)}" name="password" onmouseleave="this.type = 'password'"
                                onmouseenter="this.type = 'text'">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('PPPOE Password')}</label>
                        <div class="col-md-9">
                            <input type="password" class="form-control" id="pppoe_password" name="pppoe_password"
                                value="{$d['pppoe_password']}" onmouseleave="this.type = 'password'"
                                onmouseenter="this.type = 'text'">
                            <span class="help-block">
                                {Lang::T('User Cannot change this, only admin. if it Empty it will use user password')}
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Service Type')}</label>
                        <div class="col-md-9">
                            <select class="form-control select2" id="service_type" name="service_type">
                                <option value="Hotspot">Hotspot
                                </option>
                                <option value="PPPoE">PPPoE</option>
                                <option value="Others">Others</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                      <label class="col-md-3 control-label">{Lang::T('Router')}</label>
                        <div class="col-md-9">
                                <select id="routers" name="routers" required class="form-control select2">
                                    <option value=''>{Lang::T('Select Routers')}</option>
                                    {foreach $r as $rs}
                                        <option value="{$rs['name']}">{$rs['name']}</option>
                                    {/foreach}
                                </select>
                                <p class="help-block">{Lang::T('Cannot be change after saved')}</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-3 control-label">{Lang::T('Account Type')}</label>
                        <div class="col-md-9">
                            <select class="form-control select2" id="account_type" name="account_type">
                                <option value="Personal">Personal
                                </option>
                                <option value="Business">Business</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    
    </div>
    <center>
        <button class="btn btn-primary" type="submit">
            {Lang::T('Save Changes')}
        </button>
        <br><a href="{$_url}customers/list" class="btn btn-link">{Lang::T('Cancel')}</a>
    </center>
</form>
{literal}
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {
            var customFieldsContainer = document.getElementById('custom-fields-container');
            var addCustomFieldButton = document.getElementById('add-custom-field');

            addCustomFieldButton.addEventListener('click', function() {
                var fieldIndex = customFieldsContainer.children.length;
                var newField = document.createElement('div');
                newField.className = 'form-group';
                newField.innerHTML = `
                <div class="col-md-4">
                    <input type="text" class="form-control" name="custom_field_name[]" placeholder="Name">
                </div>
                <div class="col-md-6">
                    <input type="text" class="form-control" name="custom_field_value[]" placeholder="Value">
                </div>
                <div class="col-md-2">
                    <button type="button" class="remove-custom-field btn btn-danger btn-sm">-</button>
                </div>
            `;
                customFieldsContainer.appendChild(newField);
            });

            customFieldsContainer.addEventListener('click', function(event) {
                if (event.target.classList.contains('remove-custom-field')) {
                    var fieldContainer = event.target.parentNode.parentNode;
                    fieldContainer.parentNode.removeChild(fieldContainer);
                }
            });
        });
    </script>
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <script>
        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(showPosition);
            } else {
                setupMap(51.505, -0.09);
            }
        }

        function showPosition(position) {
            setupMap(position.coords.latitude, position.coords.longitude);
        }

        function setupMap(lat, lon) {
            var map = L.map('map').setView([lat, lon], 13);
            L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png', {
                attribution:
                    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
                    subdomains: 'abcd',
                    maxZoom: 20
            }).addTo(map);
            var marker = L.marker([lat, lon]).addTo(map);
            map.on('click', function(e){
                var coord = e.latlng;
                var lat = coord.lat;
                var lng = coord.lng;
                var newLatLng = new L.LatLng(lat, lng);
                marker.setLatLng(newLatLng);
                $('#coordinates').val(lat + ',' + lng);
            });
        }
        window.onload = function() {
            getLocation();
        }
    </script>
{/literal}


{include file="sections/footer.tpl"}