[![Gem Version](https://badge.fury.io/rb/raygun.png)](http://badge.fury.io/rb/raygun)
<img src="https://raw.github.com/carbonfive/raygun/master/marvin.jpg" align="right"/>

# Raygun

Rails application generator that builds a new project skeleton configured with Carbon Five preferences and
best practices baked right in. Spend less time configuring and more building cool features.

Raygun generates Rails projects by copying this [sample app](https://github.com/carbonfive/raygun-rails)
and massaging it gently into shape.

Alternatively, Raygun allows you to specify your own prototype instead of the default sample app. See below
for details.

Major tools/libraries:

* Rails
* PostgreSQL
* Slim
* Sass
* Bootstrap
* RSpec and Capybara
* Factory Bot
* SimpleCov
* Guard (rspec, livereload)
* And many tweaks, patterns and common recipes (see [raygun-rails](https://github.com/carbonfive/raygun-rails) for all
the details).

Raygun includes generator templates for controllers, views, and specs so that generated code follows best
practices. For example, view generation produces bootstrap compatible markup and rspec specs use factory
girl when appropriate.

Inspired by Xavier Shay work at Square and ThoughtBot's Suspenders. Thanks!

## Projects Goals

Raygun...

* Generates a new rails application that's ready for immediate feature development.
* Generates an application that has best practices that apply to most projects baked in.
* Generates an application that includes specs for all built in functionality.
* Is a forum for discussing what should or should not be included as part of a standard stack.

## Installation

    $ gem install raygun

## Prerequisites

To generate an application, you only need the Raygun gem and network connectivity.

To run your new application's specs or fire up its server, you'll need to meet these requirements.

* PostgreSQL 9.x with superuser 'postgres' with no password (`createuser -s postgres`)
* PhantomJS for JavaScript testing (`brew install phantomjs`)

The generated app will be configured to use the ruby version that was used to invoke Raygun. If you're using
another ruby, just change the `Gemfile` and `.ruby-version` as necessary.

## Usage

    $ raygun your-project

Once your project is baked out, you can easily kick the wheels. Be sure that you have the prerequisites
covered (see above).

    $ cd your-project
    $ ./bin/setup

    # Run the specs, they should all pass
    $ rake

    # Fire up the app and open it in a browser
    $ foreman start
    $ open http://localhost:3000

## Using a Custom Project Template

The default is to use the project at [carbonfive/raygun-rails](https://github.com/carbonfive/raygun-rails) as a
starting point. You can use another repo as the project template with the `-p` command line option.

If you invoke raygun with the `-p` option, you can specify your own github repository.

    $ raygun -p githubid/repo your-project

Or 

    $ raygun -p githubid/repo your-project#new-branch-name

The repository must:

Not have any binary files. Raygun runs a 'sed' command on all files, which will fail on binaries, such as jar files.

If you are not planning to pull the prototype repository by branch, it must also have a tag. Raygun will choose the
"greatest" tag and downloads the repository as of that tag.

If your project template requires a minimum version of Raygun, include the version in a file called
`.raygun-version` at the root. Raygun will make sure it's new enough for your repo.

## Internal Mechanics

Raygun fetches the greatest tag from the [carbonfive/raygun-rails](https://github.com/carbonfive/raygun-rails)
repo, unless it already has it cached in `~/.raygun`, extracts the contents of the tarball, and runs a series of
search-and-replaces on the code to customize it accordingly.

This approach is fast, simple, and makes developmentn on Raygun very easy: make changes to the application
prototype (which is a valid rails app) and tag them when they should be used for new applications.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Development

Generate an example app using your local development version of Raygun:

    $ ./bin/raygun tmp/example_app

## Changes

[View the Change Log](https://github.com/carbonfive/raygun/tree/master/CHANGES.md)
