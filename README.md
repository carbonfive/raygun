<img src="https://raw.github.com/carbonfive/raygun/master/marvin.jpg" align="right"/>

# Raygun

__NOTE: Currently a work in progress and not yet representative of best practices. Soon the veil will be lifted.__

Command line Rails application generator that builds a new project skeleton configured with all of the Carbon Five
best practices baked right in.

Inspired by and code shamelessly lifted from ThoughtBot's Suspenders. Thanks!

Major tools/libraries:

* Rails
* PostgreSQL
* Slim
* Less
* Bootstrap
* Sorcery
* Cancan
* RSpec
* Factory Girl
* Guard

And many tweaks, patterns and common recipes.

## Projects Goals

Raygun...

* should generate a new rails application that's ready for feature development immediately.* 
* should generate an application that has best practices that apply to most projects baked in.
* is a forum for discussing what should or should not be included as part of a standard stack.

## Installation

    $ gem install raygun

## Usage

__Important:__ Be sure you have a postgresql user called 'postgres' with no password.

    $ raygun your-project

Once your project is baked out, you can easily kick the wheels:

    $ cd your-project

    # Prep the database
    $ rake db:create db:migrate db:test:prepare

    # Run the specs
    $ rake spec

    # Load some sample data, fire up the app and open it in a browser
    $ rake db:seed db:sample_data
    $ rails s
    $ open http://0.0.0.0:3000

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Development

Generate an example app using your local development version of raygun

    ./bin/raygun tmp/example_app

### Customizing the generated Rails app

Changes which can be applied on top of an existing Rails app should be added as `foo_template.rb` files
 in `raygun/generators/foo/`.

Changes which must be performed during the creation of the Rails app should be added to `lib/raygun/app_builder.rb`
 and called from an appropriate step in `lib/raygun/generators/app_generator.rb`.