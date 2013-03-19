require "thor"
require "pathname"

module Raygun
  class Runner < Thor
    include Thor::Actions

    GIT_MESSAGE = "raygun-zapped skeleton"
    BANNER = "Raygun generates a new Rails application with best practices, patterns and recipes included."

    source_root File.expand_path("../../../app_prototype", __FILE__)

    desc "zap PATH", "Create an app with an earth-shattering kaboom"
    def zap(path)
      self.destination_root = path.strip
      check_target
      print_plan
      copy_prototype
      rename_new_app
      update_ruby_version
      initialize_git
      print_next_steps
    end

    no_tasks do
      def say(*arguments)
        super
        STDOUT.puts
      end

      def help(*arguments)
        say BANNER unless arguments.any?
        super
      end

      def check_target
        FileUtils.mkdir_p(destination_path) unless destination_path.exist?
        
        unless destination_path.directory?
          raise Thor::Error.new("Misfire! #{destination_path} isn't a directory!")
        end

        unless destination_path.entries.size == 2
          raise Thor::Error.new("Misfire! #{destination_path} isn't empty!")
        end
      end

      def print_plan
        say("Creating #{camel_name} in #{destination_root} ...")
      end

      def copy_prototype
        FileUtils.cp_r("#{source_path.to_s}/.", destination_path)
      end

      def rename_new_app
        replace_in_destination("AppPrototype", camel_name)
        replace_in_destination("app-prototype", dash_name)
        replace_in_destination("app_prototype", snake_name)
        replace_in_destination("App Prototype", title_name)
      end

      def update_ruby_version
        replace_in_files(prototype_patch, current_patch, ".rvmrc .ruby-version README.md")
        replace_in_files(prototype_version, current_version, "Gemfile")
      end

      def initialize_git
        system("git init", :chdir => destination_path, :out => "/dev/null")
        system("git add -A", :chdir => destination_path, :out => "/dev/null")
        system(%(git commit -m"#{GIT_MESSAGE}"), :chdir => destination_path, :out => "/dev/null")
      end
      
      def print_next_steps
        say "Done! Next steps..."

        say <<-NEXT_STEPS.gsub(/^\s+/, '')
          # Install updated dependencies
          $ cd #{destination_path.to_s}
          $ gem install bundler
          $ bundle update
        NEXT_STEPS

        say <<-NEXT_STEPS.gsub(/^\s+/, '')
          # Prepare the database: schema and reference / sample data
          $ rake db:setup db:sample_data
        NEXT_STEPS

        say <<-NEXT_STEPS.gsub(/^\s+/, '')
          # Run the specs (they should all pass)
          $ rake
        NEXT_STEPS

        say <<-NEXT_STEPS.gsub(/^\s+/, '')
          # Run the app and check things out
          $ foreman start
          $ open http://0.0.0.0:3000
        NEXT_STEPS

        say "Enjoy your Carbon Five flavored Rails application!"
      end

      def replace_in_files(original, replacement, files)
        system(
          {"LANG" => "C"},
          "#{sed_replace_command(original, replacement)} #{files}",
          :chdir => destination_path
        )
      end

      def replace_in_destination(proto_name, new_name)
        system(
          {"LANG" => "C"},
          "find . -type f -print | xargs #{sed_replace_command(proto_name, new_name)}",
          :chdir => destination_path
        )
      end

      def sed_replace_command(original, replacement)
        "#{sed_i} 's/#{original}/#{replacement}/g'"
      end

      def dash_name
        @dash_name ||= basename.gsub('_', '-')
      end

      def snake_name
        @sname_name ||= basename.gsub('-', '_')
      end

      def camel_name
        @camel_name ||= begin
          result = snake_name.sub(/^[a-z\d]*/) { $&.capitalize }
          result.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }
        end
      end

      def title_name
        @title_name ||= begin
          result = snake_name.gsub(/_/, ' ')
          result.gsub(/\b('?[a-z])/) { $1.capitalize }
        end
      end

      def source_path
        Pathname.new(self.class.source_root)
      end

      def destination_path
        Pathname.new(destination_root)
      end

      def basename
        @basename ||= destination_path.basename.to_s.gsub(/\s+/, '-')
      end
    end

    private
    def ruby_version_path
      Pathname.new(File.expand_path('../../../.ruby-version', __FILE__))
    end

    def prototype_patch
      ruby_version_path.read.strip
    end

    def prototype_version
      prototype_patch.match(/(\d\.\d\.\d).*/)[1]
    end
    
    def current_version
      RUBY_VERSION
    end

    def current_patch
      "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    end

    def sed_i
      @sed_i ||= begin
        system("sed --version &> /dev/null") ? "sed -i" : "sed -i ''"
      end
    end
  end
end
