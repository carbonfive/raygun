class ApplicationController < ActionController::Base

  #before_filter :require_login, except: [:not_authenticated]

  protect_from_forgery

  protected

  def not_authenticated
    redirect_to sign_in_path, alert: "Please sign in first."
  end

end
