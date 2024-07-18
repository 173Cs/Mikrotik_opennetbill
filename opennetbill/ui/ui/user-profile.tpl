{include file="sections/user-header.tpl"}
<!-- user-profile -->
<style>
.modal-content {
    width: 400px;
    margin: 0 auto;
    padding: 30px 0;
}

.modal-header {
    background-color: #0d0c22;
    color: #fff;
    padding: 10px 20px;
    text-align: center;
}

.modal-body {
    background-color: #f8f9fa;
    padding: 30px 40px;
    border-radius: 5px;
    
}

.form-group1 {
    margin-bottom: 20px;
}

label.control-label {
    font-weight: bold;
    font-size: 14px;
    margin-bottom: 5px;
}

.form-control {
    width: 100%;
    padding: 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif; 
}

.btn {
  
    padding: 10px 20px;
    font-size: 15px;
    font-weight: bold;
    text-align: center;
    cursor: pointer;
    border: none;
    color: white;
    border-radius: 8px;
    background-color: #0d0c22;
    /* transition: background-color 0.3s ease; */
}
.submit{
    background-color: #1a1a3e;
}

.btn.btn-success {
    background-color: #0d0c22;
    color: #fff;
}

.btn.btn-success:hover {
    background-color: #1a1a3e;
}

.text-center a {
    color: #0d0c22;
    text-decoration: none;
    transition: color 0.3s ease;
}

</style>

<div class="row">
    <div class="col-sm-12 col-md-12">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">EDIT USER</h5>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" method="post" role="form" action="{$_url}accounts/edit-profile-post">
                    <input type="hidden" name="id" value="{$d['id']}">
                    <div class="form-group1">
                        <label class="control-label">Username</label>
                        <input type="text" class="form-control" name="username" id="username" readonly value="{$d['username']}" placeholder="Phone Number">
                    </div>
                    <div class="form-group1">
                        <label class="control-label">Full Name</label>
                        <input type="text" class="form-control" id="fullname" name="fullname" value="{$d['fullname']}">
                    </div>
                    {if $_c['allow_phone_otp'] != 'yes'}
                    <div class="form-group1">
                        <label class="control-label">Phone Number</label>
                        <input type="text" class="form-control" name="phonenumber" id="phonenumber" value="{$d['phonenumber']}" placeholder="Phone Number">
                    </div>
                    {else}
                    <div class="form-group1">
                        <label class="control-label">Phone Number</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="phonenumber" id="phonenumber" value="{$d['phonenumber']}" readonly placeholder="Phone Number">
                            <span class="input-group-btn">
                                <a href="{$_url}accounts/phone-update" type="button" class="btn btn-info btn-flat">Change</a>
                            </span>
                        </div>
                    </div>
                    {/if}
                    <div class="form-group1">
                        <label class="control-label">Email</label>
                        <input type="text" class="form-control" id="email" name="email" value="{$d['email']}">
                    </div>
                    <div class="form-group1">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button class=" btn submit" type="submit">Save Changes</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
    </div>
</div>

{include file="sections/user-footer.tpl"}