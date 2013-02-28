require 'spec_helper'

# http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests

feature "Registration" do
  background do
    clear_emails

    @email = 'stan@example.com'

    visit sign_up_path

    within '#new_user' do
      fill_in 'Email',    with: @email
      fill_in 'Name',     with: 'Stan'
      fill_in 'Password', with: 'p@ssword'
      click_button 'Sign Up'
    end

    @user = User.find_by_email(@email)
  end

  after do
    @user.destroy
  end

  it "creates a new user" do
    expect(@user).to_not be_nil
  end

  it "displays a message about activation" do
    expect(find('.alert')).to have_content "Thanks for signing up. Please check your email for activation instructions."
  end

  it "sends the activation email with url" do
    expect(open_email(@email)).to_not be_nil
    expect(current_email).to have_content activation_path(@user.activation_token)
  end
end
