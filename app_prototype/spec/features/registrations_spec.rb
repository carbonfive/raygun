require 'spec_helper'

# http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests

feature "Registrations" do

  before do
    clear_emails
  end

  scenario "sign up" do
    email = 'stan.user@example.com'

    visit sign_up_path

    within '#new_user' do
      fill_in 'user_email',    with: email
      fill_in 'user_name',     with: 'Stan User'
      fill_in 'user_password', with: 'sekr1tpants'
      click_button 'Sign up'
    end

    user = User.where(email: email).first
    user.should_not be_nil

    current_path.should eq sign_in_path

    find('.alert').should have_content "Thanks for signing up. Please check your email for activation instructions."

    open_email(email).should_not be_nil
    current_email.should have_content "http://0.0.0.0:3000/sign_up/#{user.activation_token}/activate"
  end
end
