# App Prototype

...

Generated with [Raygun](https://github.com/carbonfive/raygun).

# Requirements

To run the specs or fire up the server, be sure you have these:

* Ruby 2.0.0-p247
* PostgreSQL 9.x with superuser 'postgres' with no password (```createuser -s postgres```)
* PhantomJS for JavaScript testing (```brew install phantomjs```)

# Development

### First Time Setup

After cloning, run these commands to install missing gems and prepare the database.

    $ gem install bundler
    $ bundle update
    $ rake db:setup db:sample_data

Note, ```rake db:sample_data``` loads a small set of data for development. Check out [db/sample_data.rb](db/sample_data.rb)
for details.

### Running the Specs

To run all ruby and jasmine specs.

    $ rake

Again, with coverage for the ruby specs:

    $ rake spec:coverage

### Running the Application Locally

    $ foreman start
    $ open http://0.0.0.0:3000

### Using Guard

Guard is configured to run ruby and jasmine specs, and also listen for livereload connections. Growl is used for notifications.

    $ bundle exec guard

### Using Mailcatcher

    $ gem install mailcatcher
    $ mailcatcher
    $ open http://localhost:1080/

Learn more at [mailcatcher.me](http://mailcatcher.me/). And please don't add mailcatcher to the Gemfile.

### Continuous Integration and Deployment with CircleCI

This project is configured for continuous integration and deployment with CircleCI and Heroku. Follow
these steps for first time configuration:

1. Push the project to Github, if you haven't already.
1. Authenticate at circleci.com and follow this project.
1. Be sure to enable Heroku deploys from the project settings on CircleCI.
1. The project should automatically be deployed on every successful build.

Check out [circle.yml](circle.yml) and [bin/deploy.sh](bin/deploy.sh) for details.

### Manual Deploy to Heroku

Install the Heroku toolbelt if you don't already have it (https://toolbelt.heroku.com/).

    $ heroku apps:create app-prototype
    $ git push heroku master
    $ heroku run rake db:setup

### Environment Variables

Several common features and operational parameters can be set using environment variables. These are all optional.

* ```HOSTNAME``` - Canonical hostname for this application. Other incoming requests will be redirected to this hostname.
* ```BASIC_AUTH_PASSWORD``` - Enable basic auth with this password.
* ```BASIC_AUTH_USER``` - Set a basic auth username (not required, password enables basic auth).
* ```PORT``` - Port to listen on (default: 3000).
* ```UNICORN_WORKERS``` - Number of unicorn workers to spawn (default: development 1, otherwisee 3) .
* ```UNICORN_BACKLOG``` - Depth of unicorn backlog (default: 16).

# Considerations

...
