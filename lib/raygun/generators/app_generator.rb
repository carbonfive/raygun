require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Raygun
  class AppGenerator < Rails::Generators::AppGenerator

    def finish_template
      invoke :raygun_customization
      super
    end

    def raygun_customization
      invoke :remove_files_we_dont_need
      #invoke :setup_development_environment
      #invoke :setup_staging_environment
      #invoke :create_raygun_views
      #invoke :create_common_javascripts
      #invoke :add_jquery_ui
      #invoke :customize_gemfile
      #invoke :setup_database
      #invoke :configure_app
      #invoke :setup_stylesheets
      #invoke :copy_miscellaneous_files
      #invoke :customize_error_pages
      #invoke :remove_routes_comment_lines
      #invoke :setup_root_route
      #invoke :setup_git
      #invoke :create_heroku_apps
      #invoke :create_github_repo
      invoke :outro
    end

    def remove_files_we_dont_need
      say 'Removing unneeded files.'
    end

    def outro
      say 'Congratulations!'
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end
  end
end
