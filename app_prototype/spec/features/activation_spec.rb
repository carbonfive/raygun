require 'spec_helper'

feature "Activation" do
  scenario "a successful activation" do
    @user = create(:user)
    visit "/sign_up/#{@user.activation_token}/activate" # FIXME

    expect(current_path).to eq sign_in_path
    expect(page).to have_content "Your account has been activated and you're now signed in."
  end

  scenario "an unsuccessful activation" do
    visit "/sign_up/bogus_activation_token/activate" # FIXME

    expect(current_path).to eq sign_in_path
    expect(page).to have_content "Please sign in first."
  end
end
