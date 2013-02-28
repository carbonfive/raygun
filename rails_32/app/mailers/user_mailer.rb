class UserMailer < ActionMailer::Base

  default from: 'notifications@example.com'

  def activation_needed_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to My Awesome Site!"
  end

  def activation_success_email(user)
    @user = user
    mail to: user.email, subject: "Your account has been activated!"
  end

  def reset_password_email(user)
    @user = user
    mail to: user.email, subject: "Password reset requested"
  end
end
