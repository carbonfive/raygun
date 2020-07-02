require "optparse"
require "ostruct"
require "fileutils"
require "securerandom"
require "net/http"
require "open-uri"
require "json"
require "colorize"

require_relative "version"
require_relative "template_repo"

module Raygun
  class Runner
    CARBONFIVE_REPO = "carbonfive/raygun-rails"
    C5_CONVENTIONS_REPO = "carbonfive/c5-conventions"

    attr_accessor :target_dir, :app_dir, :app_name, :dash_name, :snake_name,
                  :camel_name, :title_name, :prototype_repo,
                  :current_ruby_version, :current_ruby_patch_level

    def initialize(target_dir, prototype_repo)
      @target_dir     = target_dir
      @app_dir        = File.expand_path(target_dir.strip.to_s)
      @app_name       = File.basename(app_dir).gsub(/\s+/, "-")
      @dash_name      = app_name.tr("_", "-")
      @snake_name     = app_name.tr("-", "_")
      @camel_name     = camelize(snake_name)
      @title_name     = titleize(snake_name)
      @prototype_repo = prototype_repo

      @current_ruby_version     = RUBY_VERSION
      @current_ruby_patch_level = if RUBY_VERSION < "2.1.0" # Ruby adopted semver starting with 2.1.0.
                                    "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
                                  else
                                    RUBY_VERSION.to_s
                                  end
    end

    def check_target
      return if Dir["#{@app_dir}/*"].empty?

      puts "Misfire! The target directory isn't empty... aim elsewhere.".colorize(:light_red)
      exit 1
    end

    def fetch_prototype
      print "Checking for the latest application prototype...".colorize(:yellow)
      $stdout.flush

      # Check if we can connect, or fail gracefully and use the latest cached version.
      repo        = TemplateRepo.new(prototype_repo)
      name        = repo.name
      tarball_url = repo.tarball
      sha         = repo.sha

      print " #{name}.".colorize(:white)
      $stdout.flush

      cached_prototypes_dir = File.join(Dir.home, ".raygun")
      @prototype = "#{cached_prototypes_dir}/#{name.gsub("/", "--")}-#{sha}.tar.gz"

      # Do we already have the tarball cached under ~/.raygun?
      if File.exist?(@prototype)
        puts " Using cached version.".colorize(:yellow)
      else
        print " Downloading...".colorize(:yellow)
        $stdout.flush

        # Download the tarball and install in the cache.
        Dir.mkdir(cached_prototypes_dir, 0o755) unless Dir.exist?(cached_prototypes_dir)
        shell "curl -s -L #{tarball_url} -o #{@prototype}"
        puts " done!".colorize(:yellow)
      end
    end

    def check_raygun_version
      required_raygun_version =
        `tar xfz #{@prototype} --include "*.raygun-version" -O 2> /dev/null`.chomp ||
        ::Raygun::VERSION
      return unless Gem::Version.new(required_raygun_version) > Gem::Version.new(::Raygun::VERSION)

      puts  ""
      print "Hold up!".colorize(:red)
      print " This version of the raygun gem (".colorize(:light_red)
      print "#{::Raygun::VERSION})".colorize(:white)
      print " is too old to generate this application (needs ".colorize(:light_red)
      print required_raygun_version.to_s.colorize(:white)
      puts  " or newer).".colorize(:light_red)
      puts  ""
      print "Please update the gem by running ".colorize(:light_red)
      print "gem update raygun".colorize(:white)
      puts  ", and try again. Thanks!".colorize(:light_red)
      puts  ""
      exit 1
    end

    def copy_prototype
      FileUtils.mkdir_p(app_dir)

      shell "tar xfz #{@prototype} -C \"#{app_dir}\""

      # Github includes an extra directory layer in the tag tarball.
      extraneous_dir = Dir.glob("#{app_dir}/*").first
      dirs_to_move   = Dir.glob("#{extraneous_dir}/*", File::FNM_DOTMATCH)
        .reject { |d| %w[. ..].include?(File.basename(d)) }

      FileUtils.mv         dirs_to_move, app_dir
      FileUtils.remove_dir extraneous_dir

      fetch_rubocop_file if @prototype_repo == CARBONFIVE_REPO
    end

    def rename_new_app
      Dir.chdir(app_dir) do
        {
          "AppPrototype"  => camel_name,
          "app-prototype" => dash_name,
          "app_prototype" => snake_name,
          "App Prototype" => title_name
        }.each do |proto_name, new_name|
          shell "find . -type f -print | xargs #{sed_i} 's/#{proto_name}/#{new_name}/g'"
        end

        %w[d f].each do |find_type|
          shell "find . -depth -type #{find_type} -name '*app_prototype*' " \
                "-exec bash -c 'mv $0 ${0/app_prototype/#{snake_name}}' {} \\;"
        end
      end
    end

    def configure_new_app
      clean_up_unwanted_files

      update_ruby_version

      initialize_git
    end

    def clean_up_unwanted_files
      FileUtils.rm "#{app_dir}/.raygun-version", force: true
    end

    def update_ruby_version
      prototype_ruby_patch_level = File.read(File.expand_path("#{app_dir}/.ruby-version", __FILE__)).strip
      prototype_ruby_version     = prototype_ruby_patch_level.match(/(\d\.\d\.\d).*/)[1]

      Dir.chdir(app_dir) do
        shell "#{sed_i} 's/#{prototype_ruby_patch_level}/#{@current_ruby_patch_level}/g' .ruby-version README.md"
        shell "#{sed_i} 's/#{prototype_ruby_version}/#{@current_ruby_version}/g' Gemfile"
      end
    end

    def initialize_git
      Dir.chdir(app_dir) do
        shell "git init"
        shell "git checkout -q -b main"
        shell "git add -A ."
        shell "git commit -m 'Raygun-zapped skeleton.'"
      end
    end

    # rubocop:disable Metrics/AbcSize
    def print_plan
      puts "     ____ ".colorize(:light_yellow)
      puts '    / __ \____ ___  ______ ___  ______ '.colorize(:light_yellow)
      puts '   / /_/ / __ `/ / / / __ `/ / / / __ \ '.colorize(:light_yellow)
      puts "  / _, _/ /_/ / /_/ / /_/ / /_/ / / / / ".colorize(:light_yellow)
      puts ' /_/ |_|\__,_/\__, /\__, /\__,_/_/ /_/ '.colorize(:light_yellow)
      puts "             /____//____/ ".colorize(:light_yellow)
      puts
      puts "Raygun will create new app in directory:".colorize(:yellow) +
           " #{target_dir}".colorize(:yellow) + "...".colorize(:yellow)
      puts
      puts "-".colorize(:blue) + " Application Name:".colorize(:light_blue) +
           " #{title_name}".colorize(:light_reen)
      puts "-".colorize(:blue) + " Project Template:".colorize(:light_blue) +
           " #{prototype_repo}".colorize(:light_reen)
      puts "-".colorize(:blue) + " Ruby Version:    ".colorize(:light_blue) +
           " #{@current_ruby_patch_level}".colorize(:light_reen)
      puts
    end
    # rubocop:enable Metrics/AbcSize

    def print_next_steps
      if @prototype_repo == CARBONFIVE_REPO
        print_next_steps_carbon_five
      else
        print_next_steps_for_custom_repo
      end
    end

    # rubocop:disable Metrics/AbcSize
    def print_next_steps_carbon_five
      puts ""
      puts "Zap! Your application is ready. Next steps...".colorize(:yellow)
      puts ""
      puts "# Install updated dependencies and prepare the database".colorize(:light_green)
      puts "$".colorize(:blue) + " cd #{target_dir}".colorize(:light_blue)
      puts "$".colorize(:blue) + " bin/setup".colorize(:light_blue)
      puts ""
      puts "# Run the specs (they should all pass)".colorize(:light_green)
      puts "$".colorize(:blue) + " bin/rake".colorize(:light_blue)
      puts ""
      puts "# Run the app and check things out".colorize(:light_green)
      puts "$".colorize(:blue) + " heroku local".colorize(:light_blue)
      puts "$".colorize(:blue) + " open http://localhost:3000".colorize(:light_blue)
      puts ""
      puts "# For some suggested next steps, check out the raygun README".colorize(:light_green)
      puts "$".colorize(:blue) + " open https://github.com/carbonfive/raygun/#next-steps".colorize(:light_blue)
      puts ""
      puts "Enjoy your Carbon Five flavored Rails application!".colorize(:yellow)
    end
    # rubocop:enable Metrics/AbcSize

    def print_next_steps_for_custom_repo
      puts ""
      puts "Zap! Your application is ready.".colorize(:yellow)
      puts ""
      puts "Enjoy your raygun generated application!".colorize(:yellow)
    end

    protected

    def fetch_rubocop_file
      sha = shell("git ls-remote https://github.com/#{C5_CONVENTIONS_REPO} master") || ""
      sha = sha.slice(0..6)

      rubocop_file = "https://raw.githubusercontent.com/#{C5_CONVENTIONS_REPO}/master/rubocop/rubocop.yml"
      begin
        rubocop_contents = URI.open(rubocop_file)
        IO.write("#{@app_dir}/.rubocop.yml", <<~RUBOCOP_YML)
          # Sourced from #{C5_CONVENTIONS_REPO} @ #{sha}
          #
          # If you make changes to this file, consider opening
          # a PR to backport them to the c5-conventions repo:
          # https://github.com/#{C5_CONVENTIONS_REPO}/blob/master/rubocop/rubocop.yml

          #{rubocop_contents.string}
        RUBOCOP_YML
      rescue Errno::ENOENT, OpenURI::HTTPError => e
        puts ""
        puts "Failed to find the CarbonFive conventions rubocop file at #{rubocop_file}".colorize(:light_red)
        puts "Error: #{e}".colorize(:light_red)
        puts "You'll have to manage you're own `.rubocop.yml` setup".colorize(:light_red)
      end
    end

    def camelize(string)
      result = string.sub(/^[a-z\d]*/) { $&.capitalize }
      result.gsub(%r{(?:_|(/))([a-z\d]*)}) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }
    end

    def titleize(underscored_string)
      result = underscored_string.tr("_", " ")
      result.gsub(/\b('?[a-z])/) { Regexp.last_match(1).capitalize }
    end

    # Distinguish BSD vs GNU sed with the --version flag (only present in GNU sed).
    def sed_i
      @sed_i ||= begin
                   `sed --version &> /dev/null`
                   $?.success? ? "sed -i" : "sed -i ''"
                 end
    end

    # Run a shell command and raise an exception if it fails.
    def shell(command)
      output = `#{command}`
      raise "#{command} failed with status #{$?.exitstatus}." unless $?.success?

      output
    end

    class << self
      # rubocop:disable Metrics/MethodLength
      def parse(_args)
        raygun = nil

        options = OpenStruct.new
        options.target_dir     = nil
        options.prototype_repo = CARBONFIVE_REPO

        parser = OptionParser.new do |opts|
          opts.banner = "Usage: raygun [options] NEW_APP_DIRECTORY"

          opts.on("-h", "--help", "Show raygun usage") do
            usage_and_exit(opts)
          end
          opts.on(
            "-p",
            "--prototype [github_repo]",
            "Prototype github repo (e.g. carbonfive/raygun-rails)."
          ) do |prototype|
            options.prototype_repo = prototype
          end

          opts.on("-v", "--version", "Print the version number") do
            puts Raygun::VERSION
            exit 1
          end
        end

        begin
          parser.parse!
          options.target_dir = ARGV.first

          raise OptionParser::InvalidOption if options.target_dir.nil?

          raygun = Raygun::Runner.new(options.target_dir, options.prototype_repo)
        rescue OptionParser::InvalidOption
          usage_and_exit(parser)
        end

        raygun
      end
      # rubocop:enable Metrics/MethodLength

      def usage_and_exit(parser)
        puts parser
        exit 1
      end
    end
  end
end
