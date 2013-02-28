class RegistrationsController < ApplicationController

  skip_authorization_check

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user]) # TODO Safe attributes

    if @user.save
      redirect_to sign_in_path, notice: "Thanks for signing up. Please check your email for activation instructions."
    else
      render action: 'new'
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:token]))
      @user.activate!
      auto_login @user
      redirect_to sign_in_path, notice: "Your account has been activated and you're now signed in. Enjoy!"
    else
      not_authenticated
    end
  end

end
