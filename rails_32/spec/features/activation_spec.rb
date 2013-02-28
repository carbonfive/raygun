require 'spec_helper'

feature "Activation" do
  scenario "with a valid token should activate the user and sign them in" do
    @user = create(:user)
    visit activation_path(@user.activation_token)

    expect(current_path).to eq sign_in_path
    expect(page).to have_content "Your account has been activated and you're now signed in."
  end

  scenario "with an invalid token should send the user to sign in" do
    visit activation_path('BOGUS')

    expect(current_path).to eq sign_in_path
    expect(page).to have_content "Please sign in first."
  end
end
