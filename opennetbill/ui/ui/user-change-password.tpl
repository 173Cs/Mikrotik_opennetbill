{include file="sections/user-header.tpl"}
<!-- user-change-password -->
<style>

.modal-content {
    width: 400px;
    margin: 0 auto;
    padding: 15px 10px;
    padding-right: 2rem; 
    /* margin-left: 1rem; */
}

.modal-header {
    padding: 10px 20px;
    text-align: center; /* Center the text */
    font-size: 1rem;
    font-weight: 500;
}

.modal-body {
    background-color: #f8f9fa;
    padding: 30px 40px;
    border-radius: 5px;
    box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.1);
}

.form-group1 {
    margin-bottom: 20px;
}

label {
    font-weight: bold;
    font-size: 14px; /* Smaller font size */
    display: block;
    margin-bottom: 5px;
}

/* Adjust input width to ensure labels are above */
.form-control {
    width: 100%;
    padding: 12px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif; /* Use Poppins font */
}

/* Button styling */
.btn {
    display: inline-block;
    padding: 10px 20px;
    font-size: 18px;
    font-weight: bold;
    text-align: center;
    cursor: pointer;
    border: none;
    border-radius: 4px;
    transition: background-color 0.3s ease;
}

.btn.login-button {
    background-color: #0d0c22;
    color: #fff;
}

.btn.login-button:hover {
    background-color: #1a1a3e;
}

/* Link styling */
.text-center a {
    color: #0d0c22;
    text-decoration: none;
    transition: color 0.3s ease;
    font-family: 'Poppins', sans-serif; 
}

.text-center a:hover {
    color: #1a1a3e;
}

/* Powered by styling */
.txt2 {
    color: #0d0c22;
}

.txt2:hover {
    color: #1a1a3e;
}



</style>

<div class="row">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title">CHANGE PASSWORD</h5>
        </div>
        <div class="modal-body">
            {if {$error}}
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Oops!</strong> {$error}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            {/if}
            <form name="changePassword" action="{$_url}accounts/change-password-post" method="post">
                <div class="form-group1">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" class="form-control" name="currentPassword" id="currentPassword" placeholder="Enter your current password" required>
                </div>
                <div class="form-group1">
                    <label for="newPassword">New Password</label>
                    <input type="password" class="form-control" name="newPassword" id="newPassword" placeholder="Enter your new password" required>
                </div>
                <div class="form-group1">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Confirm your new password" required>
                </div>
                <button type="submit" class="btn login-button text-white btn-block">Change Password</button>
            </form>
            
        </div>
    </div>
</div>
</div>

{include file="sections/user-footer.tpl"}