require 'spec_helper'

feature "Password Reset" do
  background do
    clear_emails
    @user = create(:user)
    @user.activate!

    visit sign_in_path
    click_link 'Reset forgotten password'

    fill_in 'Email', with: @user.email
    click_button 'Reset My Password!'

    @user.reload
  end

  after do
    @user.destroy
  end

  scenario "displays a message about the password reset email" do
    expect(page).to have_content "Password reset instructions have been sent to your email."
    expect(current_path).to eq sign_in_path
  end

  scenario "the password reset email is sent with a reset url" do
    expect(open_email(@user.email)).to_not be_nil
    expect(current_email).to have_content edit_password_reset_path(@user.reset_password_token) # FIXME
  end

  scenario "password can be reset" do
    visit edit_password_reset_path(@user.reset_password_token)

    fill_in 'Password', with: 'some_good_password'
    click_button 'Reset Password'

    expect(page).to have_content "Password was successfully updated."
    expect(current_path).to eq sign_in_path
  end
end
