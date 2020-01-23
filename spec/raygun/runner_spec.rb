require_relative "../spec_helper"
require_relative "../../lib/raygun/raygun"

describe Raygun::Runner do
  describe "#fetch_rubocop_file" do
    context "the repo is the standard carbonfive raygun-rails repo" do
      before do
        @runner = described_class.new("target/dir", "carbonfive/raygun-rails")
        allow(URI).to receive(:open).and_return(StringIO.new("# rubocop contents"))
        allow(IO).to receive(:write)
        allow(@runner).to receive(:shell).and_return("GitSHAgoeshere")
      end
      it "inserts a copy of the rubocop file pulled from the carbonfive/c5-conventions repo" do
        @runner.send(:fetch_rubocop_file)
        expect(@runner).to have_received(:shell)
          .with("git ls-remote https://github.com/carbonfive/c5-conventions master")
        expect(URI).to have_received(:open)
          .with("https://raw.githubusercontent.com/carbonfive/c5-conventions/master/rubocop/rubocop.yml")
        expect(IO).to have_received(:write) do |path, contents|
          expect(path).to eq(File.absolute_path("target/dir/.rubocop.yml"))
          expect(contents).to include("@ GitSHA")
          expect(contents).to include("# rubocop contents")
        end
      end
    end
  end
end
