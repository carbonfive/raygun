require 'spec_helper'

feature "Sign In" do
  background(:all) do
    @user = create(:user)
    @user.activate!
  end

  after(:all) do
    @user.destroy
  end

  scenario "authenticates with valid credentials" do
    sign_in(@user.email, 'password')

    expect(find('.alert')).to have_content("Successfully signed in")
  end

  scenario "displays a generic error message with an invalid email" do
    sign_in('this is not valid', 'password')

    expect(find('.alert')).to have_content("Sign in failed")
  end

  scenario "displays a generic error message with an invalid password" do
    sign_in(@user.email, 'this is not valid')

    expect(find('.alert')).to have_content("Sign in failed")
  end
end
