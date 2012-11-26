begin
  require 'rvm'
rescue LoadError; end

module Raygun
  module RubyVersionHelpers

    # Executes the block within the configured ruby version manager. For rvm,
    # this means that any processing in the block will happen in a new gemset
    # context.
    def with_ruby_version(&block)
      setup_rvm if rvm_installed?
      yield if block_given?
    ensure
      reset_rvm if rvm_installed?
    end

    # Records the original rvm environment and sets up a new gemset.
    def setup_rvm
      @@rvm_original_env ||= RVM.current.expanded_name

      @@env = RVM::Environment.current
      @@env.gemset_create(app_name)
      @@env.gemset_use!(app_name)
    end

    # Reverts to the original rvm environment
    def reset_rvm
      @@env.use!(@@rvm_original_env)
    end

    # Returns the rbenv ruby version
    def rbenv_ruby
      `rbenv version`.split(' ').first
    end

    # Returns the RVM ruby version
    def rvm_ruby
      @@env.expanded_name.match(/([\w\-\.]+)/)[1]
    end

    # Returns true if rbenv is installed.
    def rbenv_installed?
      @rbenv_installed ||= `which rbenv`.present?
    end

    # Returns true if RVM is installed.
    def rvm_installed?
      @rvm_installed ||= `which rvm`.present?
    end
  end
end
