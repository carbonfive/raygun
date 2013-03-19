require "spec_helper"

describe "A Raygun-Generated Rails Application", integration: true do
  let(:temporary_path) { Dir.mktmpdir("raygun-integration") }
  let(:destination_path) { File.expand_path("organ-thief", temporary_path) }
  let(:raygun) { Raygun::Runner.new }

  before { raygun.zap(destination_path) }
  around { |example| Bundler.with_clean_env(&example) }

  def step(message, &block)
    RSpec.configuration.reporter.message("  #{message}")
    yield
  end

  it "is a normal rails application" do
    step "bundler runs properly" do
      Kernel.system("bundle package --all", chdir: destination_path).should be
      Kernel.system("bundle install --local --deployment", chdir: destination_path).should be
    end

    step "database migrations run" do
      Kernel.system("bundle exec rake db:setup db:sample_data", chdir: destination_path).should be
    end

    step "all generated tests pass" do
      Kernel.system("bundle exec rake", chdir: destination_path).should be
    end

    step "the rails server starts" do
      begin
        pid = Process.spawn("bundle exec rails server", chdir: destination_path)
        Godot.new("localhost", 3000, timeout: 30).wait.should be
      ensure
        Process.kill(9, pid)
      end
    end
  end
end
