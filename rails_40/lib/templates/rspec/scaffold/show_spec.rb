require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= ns_table_name %>/show" do
  before(:each) do
    @<%= ns_file_name %> = assign(:<%= ns_file_name %>, build_stubbed(:<%= class_name.underscore %>))
  end

  it "renders attributes" do
    render

<% for attribute in output_attributes -%>
    expect(rendered).to match(/<%= eval(value_for(attribute)) %>/)
<% end -%>
  end
end
