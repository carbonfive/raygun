class ApplicationController < ActionController::Base

  # Uncomment to require auth on all actions (and opt-out when necessary).
  # before_filter :require_login, except: [:not_authenticated]

  protect_from_forgery
  check_authorization

  protected

  def not_authenticated
    redirect_to sign_in_path, alert: "Please sign in first."
  end

end
