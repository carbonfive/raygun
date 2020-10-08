require_relative "../spec_helper"
require_relative "../../lib/raygun/c5_conventions"

require "tmpdir"

describe Raygun::C5Conventions do
  subject(:install) { described_class.install(target: target, sources: sources) }

  let(:target) { Dir.mktmpdir }
  let(:sources) { described_class::SOURCES }

  describe ".install" do
    it "puts rubocop files into the target directory" do
      install

      paths = %w[
        .rubocop.yml
        .rubocop-common.yml
        .rubocop-performance.yml
        .rubocop-rails.yml
        .rubocop-rspec.yml
      ].map { |path| Pathname.new(File.join(target, path)) }

      expect(paths).to all(be_file)
    end

    it "inserts an attribution header" do
      install
      rubocop_config = IO.read(File.join(target, ".rubocop.yml"))
      expect(rubocop_config).to match(%r{^# Sourced from carbonfive/c5-conventions @ \h{7}$})
    end
  end

  context "when a source doesn't exist" do
    let(:sources) { ["https://raw.githubusercontent.com/carbonfive/c5-conventions/main/rubocop/.rubocop-whatever.yml"] }

    it "prints a warning to stdout" do
      expect { install }.to output(/Failed to install/).to_stdout
    end
  end
end
