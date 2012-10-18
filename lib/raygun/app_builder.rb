module Raygun
  class AppBuilder < Rails::AppBuilder
    include Raygun::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def replace_public_index
      template '_public/index.html.erb', 'public/index.html', force: true
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def remove_application_layout
      remove_file 'app/views/layouts/application.html.erb'
    end

    def enable_factory_girl_syntax
      copy_file '_spec/support/factory_girl.rb', 'spec/support/factory_girl.rb'
    end

    def enable_threadsafe_mode
      uncomment_lines 'config/environments/production.rb', 'config.threadsafe!'
    end

    def initialize_on_precompile
      inject_into_file 'config/application.rb',
                       "\n    config.assets.initialize_on_precompile = false",
                       after: 'config.assets.enabled = true'
    end

    def setup_acceptance_environment
      run 'cp config/environments/production.rb config/environments/acceptance.rb'
    end

    def create_application_layout
      template '_app/views/layouts/application.html.slim.erb',
               'app/views/layouts/application.html.slim',
               force: true
    end

    def use_postgres_config_template
      template '_config/database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def configure_rvm
      template 'rvmrc.erb', '.rvmrc', rvm_ruby: rvm_ruby
    end

    def configure_rbenv
      template 'rbenv-version.erb', '.rbenv-version', rbenv_ruby: rbenv_ruby
    end

    def configure_gemfile
      run 'gem install bundler'
      copy_file 'Gemfile_customized', 'Gemfile', force: true
    end

    def setup_generators
      %w(_form index show new edit).each do |view|
        template = "lib/templates/slim/scaffold/#{view}.html.slim"
        remove_file template
        copy_file   "_lib/templates/slim/scaffold/#{view}.html.slim", template
      end
    end

    def configure_rspec
      generators_config = <<-RUBY

    config.generators do |generate|
      generate.stylesheets   false
      #generate.helpers       false
      generate.routing_specs false
      #generate.view_specs    false
    end

      RUBY
      inject_into_class 'config/application.rb', 'Application', generators_config

      copy_file '_lib/templates/rspec/scaffold/controller_spec.rb',
                'lib/templates/rspec/scaffold/controller_spec.rb'
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def add_rspec_support
      shared_transaction = <<-RUBY

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
#
# http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

# Turn down the logging while testing.
Rails.logger.level = 4
RUBY

      append_to_file 'spec/spec_helper.rb', shared_transaction

      copy_file '_spec/support/accept_values.rb', 'spec/support/accept_values.rb'
    end

    def add_js_testing
      directory '_spec/javascripts', 'spec/javascripts'
      copy_file '_lib/tasks/spec.rake', 'lib/tasks/spec.rake'
    end

    def configure_time_zone
      'config/application.rb'.tap do |fn|
        #inject_into_file fn, '    config.active_record.default_timezone = :utc\n', after: "'Central Time (US & Canada)'\n"
        #uncomment_lines  fn, 'config.time_zone'
        gsub_file        fn, 'Central Time (US & Canada)', 'Pacific Time (US & Canada)'
      end
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test',        "example.com"
      action_mailer_host 'acceptance',  "acceptance.#{app_name}.com"
      action_mailer_host 'production',  "#{app_name}.com"
    end

    def add_lib_to_load_path
      'config/application.rb'.tap do |fn|
        gsub_file       fn, '#{config.root}/extras', '#{config.root}/lib'
        uncomment_lines fn, 'config.autoload_paths'
      end
    end

    def setup_simple_form
      generate 'simple_form:install --bootstrap -s'

      replace_in_file 'config/initializers/simple_form.rb',
                      %(# config.label_text = lambda { |label, required| "\#{required} \#{label}" }),
                      %(config.label_text = lambda { |label, required| "\#{label}" })
    end

    def setup_authentication
      # User model
      generate 'scaffold user email:string name:string'

      remove_file 'app/models/user.rb'
      remove_file 'spec/factories/users.rb'
      remove_file 'spec/requests/users_spec.rb'
      create_users_migration = 'db/migrate/' + Dir.new('./db/migrate').entries.select { |e| e =~ /create_users/ }.first
      remove_file create_users_migration

      generate 'sorcery:install brute_force_protection activity_logging user_activation remember_me reset_password external'

      copy_file '_app/models/user.rb', 'app/models/user.rb', force: true
      copy_file '_spec/support/sorcery.rb', 'spec/support/sorcery.rb'
      copy_file '_spec/factories/users.rb', 'spec/factories/users.rb', force: true
      copy_file '_spec/models/user_spec.rb', 'spec/models/user_spec.rb', force: true

      inject_into_file 'app/controllers/users_controller.rb',
                       "\n  before_filter :require_login\n\n",
                       after: "UsersController < ApplicationController\n"

      # User mailer (has to happen before sorcery config changes)
      generate 'mailer UserMailer activation_needed_email activation_success_email reset_password_email'
      copy_file '_app/mailers/user_mailer.rb', 'app/mailers/user_mailer.rb', force: true
      copy_file '_spec/mailers/user_mailer_spec.rb', 'spec/mailers/user_mailer_spec.rb', force: true

      %w(activation_needed_email activation_success_email reset_password_email).each do |fn|
        remove_file "app/views/user_mailer/#{fn}.text.slim"

        %w(html.erb text.erb).each do |ext|
          copy_file "_app/views/user_mailer/#{fn}.#{ext}", "app/views/user_mailer/#{fn}.#{ext}", force: true
        end
      end

      remove_dir 'spec/fixtures/user_mailer'

      # Patch sorcery configuration and migrations
      sorcery_core_migration = 'db/migrate/' + Dir.new('./db/migrate').entries.select { |e| e =~ /sorcery_core/ }.first
      inject_into_file sorcery_core_migration, "      t.string :name\n", after: "create_table :users do |t|\n"
      comment_lines sorcery_core_migration, /^.* t.string :username.*$\n/

      'config/initializers/sorcery.rb'.tap do |fn|
        replace_in_file fn, 'config.user_class = "User"',        'config.user_class = User'
        replace_in_file fn, '# user.username_attribute_names =', 'user.username_attribute_names = :email'
        replace_in_file fn, '# user.user_activation_mailer =',   'user.user_activation_mailer = UserMailer'
        replace_in_file fn, '# user.reset_password_mailer =',    'user.reset_password_mailer = UserMailer'
        #replace_in_file sorcery_rb, /# user.unlock_token_mailer =.*$/,   'user.unlock_token_mailer = UserMailer'
      end

      # Routes, controllers, helpers and views
      route "resources :password_resets, only: [:new, :create, :edit, :update]"
      route "match 'sign_up/:token/activate' => 'registrations#activate', via: :get"
      route "match 'sign_up' => 'registrations#create', via: :post"
      route "match 'sign_up' => 'registrations#new', via: :get"
      route "resources :registrations, only: [:new, :create, :activate]"
      route "resources :user_sessions, only: [:new, :create, :destroy]"
      route "match 'sign_out' => 'user_sessions#destroy', as: :sign_out"
      route "match 'sign_in'  => 'user_sessions#new',     as: :sign_in"

      copy_file '_app/controllers/application_controller.rb',
                'app/controllers/application_controller.rb',
                force: true

      copy_file '_app/helpers/application_helper.rb',
                'app/helpers/application_helper.rb',
                force: true

      copy_file '_app/models/user_session.rb',
                'app/models/user_session.rb'

      copy_file '_app/controllers/user_sessions_controller.rb',
                'app/controllers/user_sessions_controller.rb'

      copy_file '_app/views/user_sessions/new.html.slim',
                'app/views/user_sessions/new.html.slim'

      copy_file '_spec/support/user_sessions_request_helper.rb',
                'spec/support/user_sessions_request_helper.rb'

      copy_file '_spec/requests/user_sessions_spec.rb',
                'spec/requests/user_sessions_spec.rb'

      copy_file '_app/controllers/registrations_controller.rb',
                'app/controllers/registrations_controller.rb'

      directory '_app/views/registrations', 'app/views/registrations'

      copy_file '_app/controllers/password_resets_controller.rb',
                'app/controllers/password_resets_controller.rb'

      directory '_app/views/password_resets', 'app/views/password_resets'

      copy_file '_app/views/password_resets/edit.html.slim',
                'app/views/password_resets/edit.html.slim'
    end

    def setup_authorization
      copy_file '_app/models/ability.rb', 'app/models/ability.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        "\ntask(:default).clear\ntask default: ['spec', 'spec:javascripts']"
      end
    end

    def setup_guard
      copy_file 'Guardfile_customized', 'Guardfile'
      run 'bundle exec guard init jasmine'
    end

    def setup_logging
      inject_into_file 'config.ru', "$stdout.sync = true\n", before: 'run ExampleApp::Application'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      directory   '_app/assets/stylesheets', 'app/assets/stylesheets'
    end

    def setup_javascripts
      inject_into_file 'app/assets/javascripts/application.js',
                       "//= require twitter/bootstrap\n",
                       after: "require jquery_ujs\n"
    end

    def copy_rake_tasks
      copy_file '_lib/tasks/db.rake', 'lib/tasks/db.rake'
      copy_file '_db/sample_data.rb', 'db/sample_data.rb'
    end

    def copy_procfile
      copy_file 'Procfile'
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb', /Application\.routes\.draw do.*end/m, "Application.routes.draw do\nend"
    end

    def convert_to_19_hash_syntax
      original_destination_root = destination_root
      inside(Raygun::AppGenerator.launch_path) do
        run "find #{original_destination_root} -name '*.rb' | xargs hash_syntax -n"
      end
    end

    def consistent_quoting
      gsub_file 'config/application.rb', '"utf-8"', "'utf-8'"
      %w(acceptance production).each do |fn|
        gsub_file "config/environments/#{fn}.rb", '"X-Sendfile"', "'X-Sendfile'"
      end
    end
  end
end
