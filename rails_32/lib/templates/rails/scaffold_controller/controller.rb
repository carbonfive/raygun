<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %>
    else
      render <%= key_value :action, '"new"' %>
    end
  end

  def update
    if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
      redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %>
    else
      render <%= key_value :action, '"edit"' %>
    end
  end

  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url
  end
end
<% end -%>
