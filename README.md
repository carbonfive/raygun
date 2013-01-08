<img src="https://raw.github.com/carbonfive/raygun/master/marvin.jpg" align="right"/>

# Raygun

Rails application generator that builds a new project skeleton configured with Carbon Five preferences and
best practices baked right in. Spend less time configuring and more building cool features.

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
* Jasmine
* SimpleCov
* Guard (rspec, jasmine, livereload)
* And many tweaks, patterns and common recipes.

Raygun includes generator templates for controllers, views, and specs so that generated code follows best
practices. For example, view generation produces bootstrap compatible markup and rspec specs use factory
girl when appropriate.

Inspired by Xavier Shay and ThoughtBot's Suspenders. Thanks!

## Projects Goals

Raygun...

* should generate a new rails application that's ready for feature development immediately.
* should generate an application that has best practices that apply to most projects baked in.
* is a forum for discussing what should or should not be included as part of a standard stack.

## Installation

    $ gem install raygun

## Prerequisites

To generate an application, you only need the raygun gem.

To run your new application's specs or fire up its server, you'll need to meet these requirements.

* PostgreSQL 9.x with superuser 'postgres' with no password (```createuser -s postgres```)
* PhantomJS for JavaScript testing (```brew install phantomjs```)

The generated app will be configured to use the ruby version that was used to invoke raygun. If you're using
another ruby, just change the ```Gemfile```, ```.rvmrc``` and/or ```.rbenv-version``` as necessary.

## Usage

    $ raygun your-project

Once your project is baked out, you can easily kick the wheels. Be sure that you have the prerequities
covered (see above).

    $ cd your-project
    $ gem install bundler
    $ bundle update

    # Prepare the database: schema and reference / sample data
    $ rake db:setup db:sample_data

    # Run the specs
    $ rake

    # Fire up the app and open it in a browser
    $ foreman start
    $ open http://0.0.0.0:3000

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Development

Generate an example app using your local development version of raygun:

    $ ./bin/raygun tmp/example_app

## Changes

[View the Change Log](https://github.com/carbonfive/raygun/tree/master/CHANGES.md)
