require 'spec_helper'

# http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests

feature "Registrations" do

  scenario "sign up" do
    visit sign_up_path
  end
end
