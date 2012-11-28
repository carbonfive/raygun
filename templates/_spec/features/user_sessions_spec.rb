require 'spec_helper'

feature "User Sessions" do

  background(:all) do
    @user = create(:user)
    @user.activate!
  end

  after(:all) do
    @user.destroy
  end

  scenario "Sign in with valid credentials" do
    sign_in(@user.email, 'password')

    find('.alert').should have_content("Successfully signed in")
  end

  scenario "Sign in with an invalid email" do
    sign_in('this is not valid', 'password')

    find('.alert').should have_content("Sign in failed")
  end

  scenario "Sign in with an invalid password" do
    sign_in(@user.email, 'this is not valid')

    find('.alert').should have_content("Sign in failed")
  end

end
