require "colorize"
require "open-uri"

module Raygun
  class C5Conventions
    REPO = "carbonfive/c5-conventions".freeze

    SOURCES = [
      "https://raw.githubusercontent.com/#{REPO}/main/rubocop/.rubocop.yml",
      "https://raw.githubusercontent.com/#{REPO}/main/rubocop/.rubocop-common.yml",
      "https://raw.githubusercontent.com/#{REPO}/main/rubocop/.rubocop-performance.yml",
      "https://raw.githubusercontent.com/#{REPO}/main/rubocop/.rubocop-rails.yml",
      "https://raw.githubusercontent.com/#{REPO}/main/rubocop/.rubocop-rspec.yml"
    ].freeze

    ATTRIBUTION_HEADER = <<~TEXT
      # Sourced from #{REPO} @ %<sha>s
      #
      # If you make changes to this file, consider opening a PR to backport them to the c5-conventions repo:
      # https://github.com/#{REPO}
    TEXT

    # Install the latest copy of c5-conventions rubocop config in the given directory.
    # If the latest files can't be downloaded from GitHub, print a warning, don't raise an exception.
    # Any existing .rubocop.yml will be overwritten.
    def self.install(target:, sources: SOURCES)
      new(target: target, sources: sources).install
    rescue Errno::ENOENT, OpenURI::HTTPError => e
      puts ""
      puts "Failed to install the CarbonFive conventions from the #{REPO} GitHub repo".colorize(:light_red)
      puts "Error: #{e}".colorize(:light_red)
      puts "You'll have to manage your own `.rubocop.yml` setup".colorize(:light_red)
    end

    def initialize(sources:, target:)
      @sources = sources
      @target = target
    end

    def install
      sources.each do |url_str|
        uri = URI(url_str)
        contents = [attribution_header, uri.open.read].join("\n")
        filename = File.basename(uri.path)

        IO.write(File.join(target, filename), contents)
      end
    end

    private

    attr_reader :sources, :target

    def attribution_header
      format(ATTRIBUTION_HEADER, sha: latest_commit_sha)
    end

    def latest_commit_sha
      @latest_commit_sha ||= begin
        stdout = `git ls-remote https://github.com/#{REPO} main`
        stdout[/^(\h{7})/, 1] || "main"
      end
    end
  end
end
