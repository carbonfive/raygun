require "spec_helper"

describe "A Generated Application", integration: true do
  let(:temporary_path) { Dir.mktmpdir("raygun-integration") }
  let(:destination_path) { File.expand_path("organ-thief", temporary_path) }
  let(:raygun) { Raygun::Runner.new }

  before { raygun.zap(destination_path) }
  around { |example| Bundler.with_clean_env(&example) }

  it "bundles all of its gems" do
    Kernel.system("bundle package --all", chdir: destination_path).should be
    Kernel.system("bundle install --local --deployment", chdir: destination_path).should be
  end

  context "after bundling" do
    before do
      Kernel.system("bundle package --all", chdir: destination_path)
      Kernel.system("bundle install --local --deployment", chdir: destination_path)
    end

    it "migrates all of its databases" do
      Kernel.system("bundle exec rake db:setup db:sample_data", chdir: destination_path).should be
    end

    context "after migrating" do
      before do
        Kernel.system("bundle exec rake db:setup db:sample_data", chdir: destination_path)
      end

      it "passes all of its tests" do
        Kernel.system("bundle exec rake", chdir: destination_path).should be
      end

      it "starts a rails server" do
        begin
          pid = Process.spawn("bundle exec rails server", chdir: destination_path)
          Godot.new("localhost", 3000, timeout: 30).wait.should be
        ensure
          Process.kill(9, pid)
        end
      end
    end
  end
end
