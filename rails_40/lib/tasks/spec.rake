begin
  require 'rspec/core'
  require 'rspec/core/rake_task'

  namespace :spec do
    desc "Run the code examples in spec/ except those in spec/features"
    RSpec::Core::RakeTask.new('without_features' => 'db:test:prepare') do |t|
      file_list = FileList['spec/**/*_spec.rb'].exclude("spec/features/**/*_spec.rb")

      t.pattern = file_list
    end
  end

rescue LoadError
  namespace :spec do
    task :without_requests do
    end
  end
end

begin
  require 'guard/jasmine/task'

  namespace :spec do
    desc "Run all javascript specs"
    task :javascripts do
      begin
        ::Guard::Jasmine::CLI.start([])

      rescue SystemExit => e
        case e.status
          when 1
            fail "Some specs have failed."
          when 2
            fail "The spec couldn't be run: #{e.message}."
        end
      end
    end

    desc 'Runs specs with coverage and cane checks'
    task cane: ['spec:enable_coverage', 'spec:coverage', 'quality']
  end

  Rake::Task['spec'].enhance do
    Rake::Task['spec:javascripts'].invoke
  end

rescue LoadError
  namespace :spec do
    task :javascripts do
      puts "Guard is not available in this environment: #{Rails.env}."
    end
  end
end


Rake::Task['spec'].clear_actions

desc 'Runs all specs'
task spec: ['spec:without_features', 'spec:features', 'spec:javascripts']
