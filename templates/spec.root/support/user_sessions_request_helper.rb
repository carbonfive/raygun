module UserSessionsRequestHelper

  def sign_in(email, password)
    visit sign_in_path

    within('#new_user_session') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_on 'Create User session'
  end

  def sign_out(user = @current_user)
    # TODO
  end

end

RSpec.configure do |config|
  config.include UserSessionsRequestHelper, type: :request
end
