require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

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
      invoke :remove_files_we_dont_need
      invoke :remove_routes_comment_lines
      invoke :setup_development_environment
      invoke :setup_production_environment
      invoke :setup_acceptance_environment
      #invoke :setup_staging_environment
      invoke :configure_rvm
      # FUTURE invoke :configure_rbenv
      invoke :customize_gemfile
      invoke :setup_database
      invoke :create_raygun_views
      invoke :configure_app
      #invoke :create_common_javascripts
      #invoke :setup_stylesheets
      #invoke :copy_miscellaneous_files
      #invoke :customize_error_pages
      invoke :setup_root_route
      #invoke :setup_git
      #invoke :create_heroku_apps
      #invoke :create_github_repo
      invoke :convert_to_19_hash_syntax
      invoke :outro
    end

    def remove_files_we_dont_need
      say "Removing unwanted files."
      build :remove_public_index
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
      say "Creating a .rvmrc file."
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

    def create_raygun_views
      say 'Creating suspenders views'
      build :create_partials_directory
      #build :create_shared_flashes
      #build :create_shared_javascripts
      build :create_application_layout
    end

    def configure_app
      say 'Configuring app'

      build :configure_rspec
      build :generate_rspec

      build :configure_time_zone
      build :configure_action_mailer
      #build :add_email_validator
      build :setup_simple_form
      build :setup_sorcery
      build :setup_default_rake_task
      #build :setup_guard
    end

    def setup_root_route
      say 'Setting up a root route'
      build :setup_root_route
    end

    def convert_to_19_hash_syntax
      build :convert_to_19_hash_syntax
    end

    def outro
      say "Enjoy your Carbon Five flavored Rails application!"
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      Raygun::AppBuilder
    end
  end
end
