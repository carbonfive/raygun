require 'spec_helper'

describe UserSessionsController do

  describe "#new" do
    it "assigns a new user as @user" do
      get :new
      expect(assigns(:user_session)).to_not be_nil
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "redirect to the target page" do
        subject.stub(:login) { build_stubbed :user }
        post :create, { user_session: { email: 'valid', password: 'valid' } }, { return_to_url: 'url' }
        expect(response).to redirect_to('url')
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template" do
        subject.stub(:login) { nil }
        post :create, { user_session: { email: 'invalid', password: 'invalid' } }
        expect(response).to render_template('new')
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested user session" do
      subject.should_receive(:logout)
      delete :destroy
    end

    it "redirects to the sign in page" do
      delete :destroy
      expect(response).to redirect_to(sign_in_url)
    end
  end

end
