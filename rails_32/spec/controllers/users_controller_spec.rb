require 'spec_helper'

describe UsersController do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :user
  end

  # This returns the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    login_user build :admin
  end

  describe "#index" do
    it "assigns all users as @users" do
      user = User.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "#show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :show, { id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "#edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :edit, { id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, { user: valid_attributes }, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, { user: valid_attributes }, valid_session
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, { user: valid_attributes }, valid_session
        expect(response).to redirect_to(User.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, { user: { "email" => "invalid value" } }, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, { user: { "email" => "invalid value" } }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = User.create! valid_attributes
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update_attributes).with({ "email" => "MyString" })
        put :update, { id: user.to_param, user: { "email" => "MyString" } }, valid_session
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        expect(response).to redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { "email" => "invalid value" } }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { "email" => "invalid value" } }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, { id: user.to_param }, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      delete :destroy, { id: user.to_param }, valid_session
      expect(response).to redirect_to(users_url)
    end
  end

end
