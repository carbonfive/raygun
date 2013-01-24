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

