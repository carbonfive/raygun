[![Gem Version](https://badge.fury.io/rb/raygun.svg)](http://badge.fury.io/rb/raygun)
<img src="https://raw.github.com/carbonfive/raygun/main/marvin.jpg" align="right"/>

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
* RSpec and Capybara
* Factory Bot
* SimpleCov
* And many tweaks, patterns and common recipes (see [raygun-rails](https://github.com/carbonfive/raygun-rails) for all
the details).

Raygun includes generator templates for controllers, views, and specs so that generated code follows best
practices. For example, rspec specs use factory bot when appropriate.

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

* PostgreSQL with superuser 'postgres' with no password (`createuser -s postgres`)

The generated app will be configured to use the ruby version that was used to invoke Raygun. If you're using
another ruby, just change the `Gemfile` and `.ruby-version` as necessary.

## Usage

```bash
$ raygun your-project
```

Once your project is baked out, you can easily kick the wheels. Be sure that you have the prerequisites
covered (see above).

```bash
$ cd your-project
$ bin/setup

# Run the specs, they should all pass
$ bin/rake

# Fire up the app and open it in a browser
$ yarn start
$ open http://localhost:3000
```

## Next Steps

### React

To add React, just run this generator:

```bash
$ bundle exec rails webpacker:install:react
```

You can use JSX in your `app/javascript` sources and the `react_component` helper in your Rails views. Your React code
will be packaged and deployed automatically with the rest of your app, and you can test it end-to-end with Capybara,
just like other Rails apps. See the [webpacker-react](https://github.com/renchap/webpacker-react) README for more
information.

> :bulb: Check out [spraygun-react](https://github.com/carbonfive/spraygun-react) for eslint and stylelint configurations that can work for React projects.

### React with Typescript

To add React with Typescript, run the React generator listed above, and then add Typescript:

```bash
$ bundle exec rails webpacker:install:typescript
```

Don't forget to rename any files containing JSX to `.tsx`.

For more information, see the [webpacker Typescript docs](https://github.com/rails/webpacker/blob/master/docs/typescript.md).

### Bootstrap

As you'll notice, the project comes with enough CSS (SCSS, actually) to establish some patterns.  If you
need more of a framework, here are instructions on how to add Bootstrap to your new project.

```bash
$ yarn add bootstrap
$ rails generate simple_form:install --bootstrap

# Answer Yes to the question about overwriting your existing `config/initializers/simple_form.rb`
```

This generates an initializer and scaffold files for Rails view scaffolding.

Add Bootstrap imports to the top your `application.scss`

```css
// application.scss
@import "~bootstrap/scss/_functions";
@import "~bootstrap/scss/_variables";

...
```

Now you've got Bootstrap in the application.

We include `simple_form` in the project by default.  For more information about using Bootstrap styling
on `simple_form` forms, check out the documentation here http://simple-form-bootstrap.plataformatec.com.br/documentation


## Using a Custom Project Template

The default is to use the project at [carbonfive/raygun-rails](https://github.com/carbonfive/raygun-rails) as a
starting point. You can use another repo as the project template with the `-p` command line option.

If you invoke raygun with the `-p` option, you can specify your own github repository.

    $ raygun -p githubid/repo your-project

Or

    $ raygun -p githubid/repo#some-template-branch your-project

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

To set up your local environment, run:

    $ bin/setup

To run tests and rubocop checks:

    $ bundle exec rake

To generate an example app using your local development version of Raygun:

    $ bin/raygun tmp/example_app

## Changes

[View the Change Log](https://github.com/carbonfive/raygun/tree/main/CHANGES.md)
