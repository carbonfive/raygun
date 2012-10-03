require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'rvm'

module Raygun
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, type: :string, aliases: '-d', default: 'postgresql',
                 desc: "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, type: :boolean, aliases: '-T', default: true,
                 desc: "Skip Test::Unit files"

    def finish_template
      invoke :raygun_customization
      super
    end

    def raygun_customization
      rvm_original_env = RVM.current.expanded_name

      invoke :remove_files_we_dont_need
      invoke :remove_routes_comment_lines
      invoke :setup_development_environment
      invoke :setup_production_environment
      invoke :setup_acceptance_environment
      #invoke :setup_staging_environment
      # FUTURE autodetect rvm or rbenv
      invoke :configure_rvm
      # FUTURE invoke :configure_rbenv
      invoke :customize_gemfile
      invoke :setup_database
      invoke :setup_generators
      invoke :create_raygun_views
      invoke :configure_app
      invoke :setup_javascripts
      invoke :setup_stylesheets
      invoke :copy_miscellaneous_files

      # Go back to the original rvm environment.
      @@env.use!(rvm_original_env)

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

    def configure_rvm
      say "Configuring RVM"

      @@env = RVM::Environment.new

      @@env.gemset_create(app_name)
      @@env.gemset_use!(app_name)

      build :configure_rvm
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

      build :configure_time_zone
      build :configure_action_mailer
      build :add_lib_to_load_path
      build :add_email_validator
      build :setup_simple_form
      build :setup_authentication
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
      say "# Prepare the database"
      say "  $ cd #{ARGV[0]}"
      say "  $ rake db:create db:migrate db:test:prepare"
      say ""
      say "# Run the specs (they should all pass)"
      say "  $ rake spec"
      say ""
      say "# Load reference and sample data, then run the app and check things out"
      say "  $ rake db:seed db:sample_data"
      say "  $ rails s"
      say "  $ open http://0.0.0.0:3000"
      say ""
      say "Enjoy your Carbon Five flavored Rails application!"
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    def rvm_ruby
      @@env.expanded_name.match(/(.*)@?/)[1]
    end

    protected

    def get_builder_class
      Raygun::AppBuilder
    end
  end
end
