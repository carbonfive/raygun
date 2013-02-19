require 'spec_helper'

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller do

  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    attributes_for :<%= file_name %>
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # <%= controller_class_name %>Controller. Be sure to keep this updated too.
  def valid_session
    {}
  end

  before do
    # TODO Set to :user and specify authorization rules in Ability.rb.
    login_user build :admin
  end

<% unless options[:singleton] -%>
  describe "#index" do
    it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
      <%= file_name %> = <%= class_name %>.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:<%= table_name %>)).to eq([<%= file_name %>])
    end
  end

<% end -%>
  describe "#show" do
    it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
      <%= file_name %> = <%= class_name %>.create! valid_attributes
      get :show, { :id => <%= file_name %>.to_param }, valid_session
      expect(assigns(:<%= ns_file_name %>)).to eq(<%= file_name %>)
    end
  end

  describe "#new" do
    it "assigns a new <%= ns_file_name %> as @<%= ns_file_name %>" do
      get :new, {}, valid_session
      expect(assigns(:<%= ns_file_name %>)).to be_a_new(<%= class_name %>)
    end
  end

  describe "#edit" do
    it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
      <%= file_name %> = <%= class_name %>.create! valid_attributes
      get :edit, { :id => <%= file_name %>.to_param }, valid_session
      expect(assigns(:<%= ns_file_name %>)).to eq(<%= file_name %>)
    end
  end

  describe "#create" do
    describe "with valid params" do
      it "creates a new <%= class_name %>" do
        expect {
          post :create, { :<%= ns_file_name %> => valid_attributes }, valid_session
        }.to change(<%= class_name %>, :count).by(1)
      end

      it "assigns a newly created <%= ns_file_name %> as @<%= ns_file_name %>" do
        post :create, {:<%= ns_file_name %> => valid_attributes }, valid_session
        expect(assigns(:<%= ns_file_name %>)).to be_a(<%= class_name %>)
        expect(assigns(:<%= ns_file_name %>)).to be_persisted
      end

      it "redirects to the created <%= ns_file_name %>" do
        post :create, { :<%= ns_file_name %> => valid_attributes }, valid_session
        expect(response).to redirect_to(<%= class_name %>.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved <%= ns_file_name %> as @<%= ns_file_name %>" do
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        post :create, { :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %> }, valid_session
        expect(assigns(:<%= ns_file_name %>)).to be_a_new(<%= class_name %>)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        post :create, { :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %> }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "#update" do
    describe "with valid params" do
      it "updates the requested <%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_attributes
        # Assuming there are no other <%= table_name %> in the database, this
        # specifies that the <%= class_name %> created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        <%= class_name %>.any_instance.should_receive(:update_attributes).with(<%= formatted_hash(example_params_for_update) %>)
        put :update, { :id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_params_for_update) %> }, valid_session
      end

      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_attributes
        put :update, { :id => <%= file_name %>.to_param, :<%= ns_file_name %> => valid_attributes }, valid_session
        expect(assigns(:<%= ns_file_name %>)).to eq(<%= file_name %>)
      end

      it "redirects to the <%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_attributes
        put :update, { :id => <%= file_name %>.to_param, :<%= ns_file_name %> => valid_attributes }, valid_session
        expect(response).to redirect_to(<%= file_name %>)
      end
    end

    describe "with invalid params" do
      it "assigns the <%= ns_file_name %> as @<%= ns_file_name %>" do
        <%= file_name %> = <%= class_name %>.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        put :update, { :id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %> }, valid_session
        expect(assigns(:<%= ns_file_name %>)).to eq(<%= file_name %>)
      end

      it "re-renders the 'edit' template" do
        <%= file_name %> = <%= class_name %>.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        <%= class_name %>.any_instance.stub(:save).and_return(false)
        put :update, { :id => <%= file_name %>.to_param, :<%= ns_file_name %> => <%= formatted_hash(example_invalid_attributes) %> }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "#destroy" do
    it "destroys the requested <%= ns_file_name %>" do
      <%= file_name %> = <%= class_name %>.create! valid_attributes
      expect {
        delete :destroy, { :id => <%= file_name %>.to_param }, valid_session
      }.to change(<%= class_name %>, :count).by(-1)
    end

    it "redirects to the <%= table_name %> list" do
      <%= file_name %> = <%= class_name %>.create! valid_attributes
      delete :destroy, { :id => <%= file_name %>.to_param }, valid_session
      expect(response).to redirect_to(<%= index_helper %>_url)
    end
  end

end
<% end -%>
