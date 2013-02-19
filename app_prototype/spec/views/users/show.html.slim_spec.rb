require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, build_stubbed(:user))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match /Email/
    expect(rendered).to match /Name/
  end
end
