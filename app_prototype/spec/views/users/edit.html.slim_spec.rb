require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, build_stubbed(:user))
  end

  it "renders the edit user form" do
    render

    assert_select "form", action: users_path(@user), method: "post" do
      assert_select "input#user_email", name: "user[email]"
      assert_select "input#user_name", name: "user[name]"
    end
  end
end
