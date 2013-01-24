begin
  require 'cane/rake_task'
  require 'morecane'

  desc "Run cane to check quality metrics"
  Cane::RakeTask.new(:quality) do |cane|
    cane.add_threshold 'coverage/covered_percent', :>=, 95

    cane.no_style      = false # Change to true to skip style checks
    cane.style_measure = 120   # Maximum line length
    cane.style_exclude = %w{
      lib/templates/rspec/scaffold/controller_spec.rb
    }

    cane.no_doc = true # Change to false to enable documentation checks

    cane.abc_max = 15 # Fail the build if complexity is too high.
    # cane.abc_exclude = %w(
    #   User#bad_code_rising
    # )

    # Fail the build if the code includes debugging statements
    cane.use Morecane::MustNotMatchCheck,
      must_not_match_glob: "{app,lib,config,spec}/**/*.rb",
      must_not_match_regexp: /binding\.pry|debugger/
  end

rescue LoadError
  warn "cane not available, quality task not provided."
end
