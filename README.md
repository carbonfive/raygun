# Raygun

__NOTE: Currently a work in progress and not yet representative of best practices. Soon the veil will be lifted.__

Command line Rails application generator that builds a new project skeleton configured with all of the Carbon Five
best practices baked right in.

Inspired by and code shamelessly lifted from ThoughtBot's Suspenders. Thanks!

Tools/libraries:

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

And many tweaks and common recipes.

## Installation

    $ gem install raygun

## Usage

    $ raygun --help

    $ raygun your-project [options]

Once your project is baked out, you can easily kick the wheels:

    $ cd your-project
    $ rake db:create db:migrate
    $ rake db:test:prepare spec
    $ rake db:populate
    $ rails s

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
