module Raygun
  class AppBuilder < Rails::AppBuilder
    include Raygun::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def remove_application_layout
      remove_file 'app/views/layouts/application.html.erb'
    end

    def raise_delivery_errors
      replace_in_file 'config/environments/development.rb',
                      'raise_delivery_errors = false',
                      'raise_delivery_errors = true'
    end

    def enable_factory_girl_syntax
      copy_file 'spec.root/support/factory_girl.rb', 'spec/support/factory_girl.rb'
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

    def create_partials_directory
      #empty_directory 'app/views/application'
    end

    #def create_shared_flashes
    #  copy_file '_flashes.html.slim', 'app/views/application/_flashes.html.slim'
    #end

    #def create_shared_javascripts
    #  copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    #end

    def create_application_layout
      template 'app.root/views/layouts/application.html.slim.erb',
               'app/views/layouts/application.html.slim',
               force: true
    end

    #def create_common_javascripts
    #  directory 'javascripts', 'app/assets/javascripts'
    #end

    def use_postgres_config_template
      template 'config.root/database.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def configure_rvm
      template 'rvmrc.erb', '.rvmrc', rvm_ruby: rvm_ruby
    end

    def configure_gemfile
      run "gem install bundler"
      copy_file 'Gemfile_customized', 'Gemfile', force: true
    end

    def setup_generators
      %w(_form index show new edit).each do |view|
        template = "lib/templates/slim/scaffold/#{view}.html.slim"
        remove_file template
        copy_file   "lib.root/templates/slim/scaffold/#{view}.html.slim", template
      end
    end

    #def add_custom_gems
    #  additions_path = find_in_source_paths 'Gemfile_additions'
    #  new_gems = File.open(additions_path).read
    #  inject_into_file 'Gemfile', "\n#{new_gems}",
    #    :after => /gem 'jquery-rails'/
    #end

    #def add_clearance_gem
    #  inject_into_file 'Gemfile', "\ngem 'clearance'",
    #    :after => /gem 'jquery-rails'/
    #end
    #
    #def add_capybara_webkit_gem
    #  inject_into_file 'Gemfile', "\n  gem 'capybara-webkit', '~> 0.11.0'",
    #    :after => /gem 'cucumber-rails', '1.3.0', :require => false/
    #end

    def configure_rspec
      generators_config = <<-RUBY

    config.generators do |generate|
      generate.stylesheets false
      #generate.helpers     false
      generate.route_specs false
      #generate.view_specs  false
    end

      RUBY
      inject_into_class 'config/application.rb', 'Application', generators_config
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def add_rspec_support
      copy_file 'spec.root/support/accept_values.rb', 'spec/support/accept_values.rb'
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

    def add_email_validator
      # CN: I'm not thrilled with this use of the lib directory, but it's not that unusual. Would love to hear what
      # other folks think about where such things should live.
      copy_file 'lib.root/email_validator.rb', 'lib/email_validator.rb'
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
      create_users_migration = 'db/migrate/' + Dir.new('./db/migrate').entries.select { |e| e =~ /create_users/ }.first
      remove_file create_users_migration

      generate 'sorcery:install brute_force_protection activity_logging user_activation remember_me reset_password external'

      copy_file 'app.root/models/user.rb', 'app/models/user.rb', force: true
      copy_file 'spec.root/factories/users.rb', 'spec/factories/users.rb', force: true
      copy_file 'spec.root/models/user_spec.rb', 'spec/models/user_spec.rb', force: true

      gsub_file 'spec/controllers/users_controller_spec.rb',
                /(valid_attributes\n\s*)\{\}/,
                '\1FactoryGirl.attributes_for(:user)'

      # User mailer (has to happen before sorcery config changes)
      generate 'mailer UserMailer activation_needed_email activation_success_email reset_password_email'
      copy_file 'app.root/mailers/user_mailer.rb', 'app/mailers/user_mailer.rb', force: true
      copy_file 'spec.root/mailers/user_mailer_spec.rb', 'spec/mailers/user_mailer_spec.rb', force: true

      %w(activation_needed_email activation_success_email reset_password_email).each do |fn|
        remove_file "app/views/user_mailer/#{fn}.text.slim"

        %w(html.erb text.erb).each do |ext|
          copy_file "app.root/views/user_mailer/#{fn}.#{ext}", "app/views/user_mailer/#{fn}.#{ext}", force: true
        end
      end

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
      route "match 'sign_in'  => 'user_sessions#new',     as: :sign_in"
      route "match 'sign_out' => 'user_sessions#destroy', as: :sign_out"
      route "resources :user_sessions, only: [:new, :create, :destroy]"

      copy_file 'app.root/controllers/application_controller.rb',
                'app/controllers/application_controller.rb',
                force: true

      copy_file 'app.root/helpers/application_helper.rb',
                'app/helpers/application_helper.rb',
                force: true

      copy_file 'app.root/models/user_session.rb',
                'app/models/user_session.rb'

      copy_file 'app.root/controllers/user_sessions_controller.rb',
                'app/controllers/user_sessions_controller.rb'

      copy_file 'app.root/views/user_sessions/new.html.slim',
                'app/views/user_sessions/new.html.slim'

    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'app.root/assets/stylesheets/application.css.less', 'app/assets/stylesheets/application.css.less'
    end

    #def setup_guard
    #  copy_file 'Guardfile', 'Guardfile'
    #end

    #def setup_stylesheets
    #  copy_file 'app/assets/stylesheets/application.css', 'app/assets/stylesheets/application.css.scss'
    #  remove_file 'app/assets/stylesheets/application.css'
    #  concat_file 'import_scss_styles', 'app/assets/stylesheets/application.css.scss'
    #  create_file 'app/assets/stylesheets/_screen.scss'
    #end

    #def gitignore_files
    #  concat_file 'suspenders_gitignore', '.gitignore'
    #  ['app/models',
    #    'app/assets/images',
    #    'app/views/pages',
    #    'db/migrate',
    #    'log',
    #    'spec/support',
    #    'spec/lib',
    #    'spec/models',
    #    'spec/views',
    #    'spec/controllers',
    #    'spec/helpers',
    #    'spec/support/matchers',
    #    'spec/support/mixins',
    #    'spec/support/shared_examples'].each do |dir|
    #    empty_directory_with_gitkeep dir
    #  end
    #end

    #def init_git
    #  run 'git init'
    #end

    #def create_heroku_apps
    #  path_addition = override_path_for_tests
    #  run "#{path_addition} heroku create #{app_name}-production --remote=production"
    #  run "#{path_addition} heroku create #{app_name}-staging    --remote=staging"
    #end

    #def create_github_repo(repo_name)
    #  path_addition = override_path_for_tests
    #  run "#{path_addition} hub create #{repo_name}"
    #end

    #def copy_miscellaneous_files
    #  copy_file 'errors.rb', 'config/initializers/errors.rb'
    #  copy_file 'Procfile'
    #end

#    def customize_error_pages
#      meta_tags =<<-EOS
#  <meta charset='utf-8' />
#  <meta name='ROBOTS' content='NOODP' />
#      EOS
#      style_tags =<<-EOS
#<link href='/assets/application.css' media='all' rel='stylesheet' type='text/css' />
#      EOS
#      %w(500 404 422).each do |page|
#        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
#        replace_in_file "public/#{page}.html", /<style.+>.+<\/style>/mi, style_tags.strip
#        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
#      end
#    end

    def setup_root_route
      route "\n  root to: 'user_sessions#new'"
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb', /Application\.routes\.draw do.*end/m, "Application.routes.draw do\nend"
    end

    #def set_attr_accessibles_on_user
    #  inject_into_file 'app/models/user.rb',
    #    "  attr_accessible :email, :password\n",
    #    :after => /include Clearance::User\n/
    #end

    #def include_clearance_matchers
    #  create_file 'spec/support/clearance.rb', "require 'clearance/testing'"
    #end

    #def setup_default_rake_task
    #  append_file 'Rakefile' do
    #    "task(:default).clear\ntask :default => [:spec, :cucumber]"
    #  end
    #end

    def convert_to_19_hash_syntax
      run 'hash_syntax -n'

      # Borrowed from http://devign.me/convert-ruby-hash-syntax-to-1-9/
      #Dir['**/*.rb'].each do |f|
      #  s = open(f).read
      #  awesome_rx = /(?<!return)(?<!:)(?<!\w)(\s+):(\w+)\s*=>/
      #  count = s.scan(awesome_rx).length
      #  next if count.zero?
      #  s.gsub!(awesome_rx, '\1\2:')
      #  #puts "#{count} replacements @ #{f}"
      #  open(f, 'w') { |b| b << s }
      #end
    end

    def consistent_quoting
      gsub_file 'config/application.rb', '"utf-8"', "'utf-8'"
      %w(acceptance production).each do |fn|
        gsub_file "config/environments/#{fn}.rb", '"X-Sendfile"', "'X-Sendfile'"
      end
    end

    private

    #def override_path_for_tests
    #  if ENV['TESTING']
    #    support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
    #    "PATH=#{support_bin}:$PATH"
    #  end
    #end
  end
end
