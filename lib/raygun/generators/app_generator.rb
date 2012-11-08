module Raygun
  class AppGenerator < Rails::Generators::AppGenerator
    include Raygun::RubyVersionHelpers

    # set and get raygun launch path
    def self.launch_path(path=nil)
      @_launch_path = path if path
      @_launch_path
    end

    class_option :database, type: :string, aliases: '-d', default: 'postgresql',
                 desc: "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, type: :boolean, aliases: '-T', default: true,
                 desc: "Skip Test::Unit files"

    def finish_template
      invoke :raygun_customization
      super
    end

    def raygun_customization

      with_ruby_version do
        invoke :remove_files_we_dont_need
        invoke :remove_routes_comment_lines
        invoke :setup_development_environment
        invoke :setup_production_environment
        invoke :setup_acceptance_environment
        #invoke :setup_staging_environment
        invoke :configure_ruby_version
        invoke :customize_gemfile
        invoke :setup_database
        invoke :setup_generators
        invoke :create_raygun_views
        invoke :configure_app
        invoke :setup_javascripts
        invoke :setup_stylesheets
        invoke :copy_miscellaneous_files
      end

      invoke :knits_and_picks
      invoke :outro
    end

    def remove_files_we_dont_need
      say "Removing unwanted files."
      build :remove_rails_logo_image
      build :remove_application_layout
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_development_environment
      say "Setting up the development environment."
      build :raise_delivery_errors
      build :enable_factory_girl_syntax
    end

    def setup_production_environment
      say "Setting up the production environment."
      build :enable_threadsafe_mode
    end

    def setup_acceptance_environment
      say "Setting up the acceptance environment."
      build :setup_acceptance_environment
      build :initialize_on_precompile
    end

    def configure_ruby_version
      if rvm_installed?
        say "Configuring RVM"
        build :configure_rvm
      else
        say "Configuring rbenv"
        build :configure_rbenv
      end
    end

    def customize_gemfile
      say "Customizing the Gemfile."
      build :configure_gemfile
      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'
      build :use_postgres_config_template
      build :create_database
    end

    def setup_generators
      say 'Installing custom view generator templates'
      build :setup_generators
    end

    def create_raygun_views
      say 'Creating views and layouts'
      build :replace_public_index
      build :create_partials_directory
      #build :create_shared_flashes
      #build :create_shared_javascripts
      build :create_application_layout
    end

    def configure_app
      say 'Configuring app'

      build :configure_rspec
      build :generate_rspec
      build :add_rspec_support

      build :add_js_testing

      build :setup_logging
      build :configure_time_zone
      build :configure_action_mailer
      build :add_lib_to_load_path
      build :setup_simple_form
      build :setup_authentication
      build :setup_authorization
      build :setup_simplecov
      build :setup_default_rake_task
      build :setup_guard
    end

    def setup_stylesheets
      say "Configuring stylesheets"
      build :setup_stylesheets
    end

    def setup_javascripts
      say "Configuring javascripts"
      build :setup_javascripts
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_rake_tasks
      build :copy_procfile
    end

    def knits_and_picks
      say 'Converting old hash syntax and fixing knit picks'
      build :convert_to_19_hash_syntax
      build :consistent_quoting
    end

    def outro
      say ""
      say "You're done! Next steps..."
      say ""
      say "# Prepare the database: schema and reference / sample data"
      say "$ cd #{ARGV[0]}"
      say "$ rake db:migrate db:seed db:sample_data"
      say ""
      say "# Run the specs (they should all pass)"
      say "$ rake"
      say ""
      say "# Load reference and sample data, then run the app and check things out"
      say "$ foreman start"
      say "$ open http://0.0.0.0:3000"
      say ""
      say "Enjoy your Carbon Five flavored Rails application!"
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      Raygun::AppBuilder
    end

    # We want output from our bundle commands, overriding thor's implementation.
    def bundle_command(command)
      say_status :run, "bundle #{command}"
      cmd = "#{Gem.ruby} -rubygems #{Gem.bin_path('bundler', 'bundle')} #{command}"
      IO.popen(cmd) { |p| p.each { |f| puts f } }
    end

  end
end
