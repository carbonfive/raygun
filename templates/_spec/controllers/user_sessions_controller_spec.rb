require 'spec_helper'

describe UserSessionsController do

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
      assigns(:user_session).should_not be_nil
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "redirect to the target page" do
        subject.stub(:login) { build_stubbed :user }
        post :create, { user_session: { email: 'valid', password: 'valid' } }, { return_to_url: 'url' }
        response.should redirect_to('url')
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template" do
        subject.stub(:login) { nil }
        post :create, { user_session: { email: 'invalid', password: 'invalid' } }
        response.should render_template('new')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user session" do
      subject.should_receive(:logout)
      delete :destroy
    end

    it "redirects to the sign in page" do
      delete :destroy
      response.should redirect_to(sign_in_url)
    end
  end

end
