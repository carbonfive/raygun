require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= ns_table_name %>/new" do
  before(:each) do
    assign(:<%= ns_file_name %>, build_stubbed(:<%= class_name.underscore %>))
  end

  it "renders new <%= ns_file_name %> form" do
    render

    assert_select "form", action: <%= index_helper %>_path, method: "post" do
<% for attribute in output_attributes -%>
      assert_select "<%= attribute.input_type -%>#<%= ns_file_name %>_<%= attribute.name %>", name: "<%= ns_file_name %>[<%= attribute.name %>]"
<% end -%>
    end
  end
end

