class PasswordResetsController < ApplicationController

  skip_before_filter :require_login
  skip_authorization_check

  def create
    @user = User.find_by_email(params[:email])

    # Send an email to the user with instructions on how to reset their password.
    @user.deliver_reset_password_instructions! if @user

    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    redirect_to sign_in_path, notice: "Password reset instructions have been sent to your email."
  end

  def edit
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if !@user
  end

  def update
    @token = params[:token] # needed to render the form again in case of error
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if !@user

    # Clear the temporary token and update the password.
    if @user.change_password!(params[:user][:password])
      redirect_to sign_in_path, notice: "Password was successfully updated."
    else
      render action: 'edit'
    end
  end

end
