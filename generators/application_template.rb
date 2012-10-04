Dir.chdir(File.dirname(__FILE__)) do
  Dir.glob("*_template.rb") do |template|
    apply template unless template == File.basename(__FILE__)
  end
end