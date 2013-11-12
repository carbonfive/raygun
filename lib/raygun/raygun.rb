require 'optparse'
require 'ostruct'
require 'fileutils'
require 'securerandom'
require 'net/http'
require 'json'
require 'colorize'

require_relative 'version'

module Raygun
  class Runner
    attr_accessor :target_dir, :app_dir, :app_name, :dash_name, :snake_name, :camel_name, :title_name, :prototype_repo

    def initialize(target_dir, prototype_repo)
      @target_dir     = target_dir
      @app_dir        = File.expand_path(target_dir.strip.to_s)
      @app_name       = File.basename(app_dir).gsub(/\s+/, '-')
      @dash_name      = app_name.gsub('_', '-')
      @snake_name     = app_name.gsub('-', '_')
      @camel_name     = camelize(snake_name)
      @title_name     = titleize(snake_name)
      @prototype_repo = prototype_repo
    end

    def check_target
      unless Dir["#{@app_dir}/*"].empty?
        puts "Misfire! The target directory isn't empty... aim elsewhere."
        exit 1
      end
    end

    def fetch_prototype
      print "Checking for the latest application prototype...".colorize(:yellow)
      $stdout.flush

      # Check if we can connect, or fail gracefully and use the latest cached version.
      latest_tag_obj = fetch_latest_tag(prototype_repo)
      latest_tag     = latest_tag_obj['name']
      tarball_url    = latest_tag_obj['tarball_url']

      print " #{latest_tag}.".colorize(:white)
      $stdout.flush

      cached_prototypes_dir = File.join(Dir.home, ".raygun")
      @prototype = "#{cached_prototypes_dir}/#{prototype_repo.sub('/', '--')}-#{latest_tag}.tar.gz"

      # Do we already have the tarball cached under ~/.raygun?
      if File.exists?(@prototype)
        puts " Using cached version.".colorize(:yellow)
      else
        print " Downloading...".colorize(:yellow)
        $stdout.flush

        # Download the tarball and install in the cache.
        Dir.mkdir(cached_prototypes_dir, 0755) unless Dir.exists?(cached_prototypes_dir)

        shell "wget -q #{tarball_url} -O #{@prototype}"
        puts " done!".colorize(:yellow)
      end
    end

    def check_raygun_version
      required_raygun_version =
        %x{tar xfz #{@prototype} --include "*.raygun-version" -O 2> /dev/null}.chomp ||
          ::Raygun::VERSION

      if Gem::Version.new(required_raygun_version) > Gem::Version.new(::Raygun::VERSION)
        puts  ""
        print "Hold up!".colorize(:red)
        print " This version of the raygun gem (".colorize(:light_red)
        print "#{::Raygun::VERSION})".colorize(:white)
        print " is too old to generate this application (needs ".colorize(:light_red)
        print "#{required_raygun_version}".colorize(:white)
        puts  " or newer).".colorize(:light_red)
        puts  ""
        print "Please update the gem by running ".colorize(:light_red)
        print "gem update raygun".colorize(:white)
        puts  ", and try again. Thanks!".colorize(:light_red)
        puts  ""
        exit 1
      end
    end

    def copy_prototype
      FileUtils.mkdir_p(app_dir)

      shell "tar xfz #{@prototype} -C #{app_dir}"

      extraneous_dir = Dir.glob("#{app_dir}/*").first
      dirs_to_move   = Dir.glob("#{extraneous_dir}/*", File::FNM_DOTMATCH)
                          .reject { |d| %w{. ..}.include?(File.basename(d)) }

      FileUtils.mv         dirs_to_move, app_dir
      FileUtils.remove_dir extraneous_dir
    end

    def rename_new_app
      Dir.chdir(app_dir) do
        {
          'AppPrototype'  => camel_name,
          'app-prototype' => dash_name,
          'app_prototype' => snake_name,
          'App Prototype' => title_name
        }.each do |proto_name, new_name|
          shell "find . -type f -print | xargs #{sed_i} 's/#{proto_name}/#{new_name}/g'"
        end
      end
    end

    def configure_new_app
      update_ruby_version
      initialize_git
    end

    def update_ruby_version
      prototype_ruby_patch_level = File.read(File.expand_path("#{app_dir}/.ruby-version", __FILE__)).strip
      prototype_ruby_version     = prototype_ruby_patch_level.match(/(\d\.\d\.\d).*/)[1]
      current_ruby_version       = RUBY_VERSION
      current_ruby_patch_level   = "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"

      Dir.chdir(app_dir) do
        shell "#{sed_i} 's/#{prototype_ruby_patch_level}/#{current_ruby_patch_level}/g' .ruby-version README.md"
        shell "#{sed_i} 's/#{prototype_ruby_version}/#{current_ruby_version}/g' Gemfile"
      end
    end

    def initialize_git
      Dir.chdir(app_dir) do
        shell "git init"
        shell "git add -A ."
        shell "git commit -m 'Raygun-zapped skeleton.'"
      end
    end

    def print_plan
      puts '     ____ '.colorize(:light_yellow)
      puts '    / __ \____ ___  ______ ___  ______ '.colorize(:light_yellow)
      puts '   / /_/ / __ `/ / / / __ `/ / / / __ \ '.colorize(:light_yellow)
      puts '  / _, _/ /_/ / /_/ / /_/ / /_/ / / / / '.colorize(:light_yellow)
      puts ' /_/ |_|\__,_/\__, /\__, /\__,_/_/ /_/ '.colorize(:light_yellow)
      puts '             /____//____/ '.colorize(:light_yellow)
      puts
      puts "Raygun will creating new app in directory".colorize(:yellow) + " #{target_dir}".colorize(:yellow) + "...".colorize(:yellow)
      puts
      puts "-".colorize(:blue) + " Application Name:".colorize(:light_blue) + " #{title_name}".colorize(:light_reen)
      puts "-".colorize(:blue) + " Project Template:".colorize(:light_blue) + " #{prototype_repo}".colorize(:light_reen)
      puts "-".colorize(:blue) + " Ruby Version:    ".colorize(:light_blue) + " #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".colorize(:light_reen)
      puts
    end

    def print_next_steps
      puts ""
      puts "Zap! Your application is ready. Next steps...".colorize(:yellow)
      puts ""
      puts "# Install updated dependencies".colorize(:light_green)
      puts "$".colorize(:blue) + " cd #{target_dir}".colorize(:light_blue)
      puts "$".colorize(:blue) + " gem install bundler".colorize(:light_blue)
      puts "$".colorize(:blue) + " bundle".colorize(:light_blue)
      puts ""
      puts "# Prepare the database: schema and reference / sample data".colorize(:light_green)
      puts "$".colorize(:blue) + " rake db:setup db:sample_data".colorize(:light_blue)
      puts ""
      puts "# Run the specs (they should all pass)".colorize(:light_green)
      puts "$".colorize(:blue) + " rake".colorize(:light_blue)
      puts ""
      puts "# Run the app and check things out".colorize(:light_green)
      puts "$".colorize(:blue) + " foreman start".colorize(:light_blue)
      puts "$".colorize(:blue) + " open http://0.0.0.0:3000".colorize(:light_blue)
      puts ""
      puts "Enjoy your Carbon Five flavored Rails application!".colorize(:yellow)
    end

    protected

    # Fetch the tags for the repo (e.g. 'carbonfive/raygun-rails4') and return the latest as JSON.
    def fetch_latest_tag(repo)
      url          = "https://api.github.com/repos/#{@prototype_repo}/tags"
      uri          = URI.parse(url)
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request      = Net::HTTP::Get.new(URI.encode(url))
      JSON.parse(http.request(request).body).first
    end

    def camelize(string)
      result = string.sub(/^[a-z\d]*/) { $&.capitalize }
      result.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }
    end

    def titleize(underscored_string)
      result = underscored_string.gsub(/_/, ' ')
      result.gsub(/\b('?[a-z])/) { $1.capitalize }
    end

    # Distinguish BSD vs GNU sed with the --version flag (only present in GNU sed).
    def sed_i
      @sed_format ||= begin
        %x{sed --version &> /dev/null}
        $?.success? ? "sed -i" : "sed -i ''"
      end
    end

    # Run a shell command and raise an exception if it fails.
    def shell(command)
      %x{#{command}}
      raise "#{command} failed with status #{$?.exitstatus}." unless $?.success?
    end

    def self.parse(args)
      raygun = nil

      options = OpenStruct.new
      options.target_dir     = nil
      options.prototype_repo = 'carbonfive/raygun-rails4'

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: raygun [options] NEW_APP_DIRECTORY"

        opts.on('-h', '--help', "Show raygun usage") do |variable|
          usage_and_exit(opts)
        end
        #opts.on('-p', '--prototype', "Prototype github repo (e.g. carbonfive/raygun).") do |prototype|
        #  options.prototype_repo = prototype_repo
        #end
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

    def self.usage_and_exit(parser)
      puts parser
      exit 1
    end
  end
end
