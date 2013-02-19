require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, build_stubbed(:user))
  end

  it "renders new user form" do
    render

    assert_select "form", action: users_path, method: "post" do
      assert_select "input#user_email", name: "user[email]"
      assert_select "input#user_name", name: "user[name]"
    end
  end
end
