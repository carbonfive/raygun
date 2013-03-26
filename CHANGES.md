# Change Log

## 0.0.28 [2013-03-26]

* Use unicorn by default instead of thin, as per heroku's recommendation.
* Suppress schema dumping unless run in development mode to eliminate pg_dump errors on heroku during db:migrate.
* Tweak mailcacher configuration so that it only sets smtp_settings when mailchacher is running.

## 0.0.27 [2013-02-27]

* Make sure the target directory is empty, otherwise misfire.
* Use ruby-1.9.3-p392 for the project (new apps still use the version that invoked raygun) (thanks @rpak).
* Better detection of BSD vs GNU sed (thanks @orangejulius).

## 0.0.26 [2013-02-24]

* Validate presense of name on User.
* Drop rspec and capybara version constraints from the Gemfile.

## 0.0.25 [2013-02-20]

* Generated controller specs now pass without intervention.
* Generated view specs use factory_girl's build_stubbed instead of rspec's stub_model, expect() syntax, and 1.9 hash syntax.
* Initialize git and create an initial commit (thanks @blakeeb).

## 0.0.24 [2013-02-14]

* Upgrade to ruby-1.9.3-p385 (thanks @mechfish).
* Upgrade to rails ~> 3.2.12 (thanks @mechfish).
* Pay attention to shelled command's exit status and bail with a message if a command fails.

## 0.0.23 [2013-02-07]

* Fixed a bug with detecting whether we're on darwin or not.
* Remove some dead code (thanks @bemurphy).

## 0.0.22 [2013-02-07]

* Support ubuntu and darwin (sed has slightly different syntax for in-place substitution).
* Take lib off the load path by default.

## 0.0.21 [2013-02-01]

* Turn off threadsafe when running rake tasks (thanks @subakva).

## 0.0.20 [unreleased]

* Bug fix and minor output tweak.

## 0.0.19 [2013-01-29]

* Pull the rails secret token from the environment so it can be easily set in server environments.
* Dump the static index.html for a dynamic version.

## 0.0.18 [2013-01-24]

* Support generating an app in the current directory (thanks @subakva).
* Better handling of command line arguments (thanks @subakva).
* Include support for cane quality checks via ```rake spec:cane``` (thanks @subakva).

## 0.0.17 [2013-01-17]

* Configure .ruby-version, .rvmrc, and Gemfile with the version of ruby used to execute raygun.
* Improve the default email content.
* Improve the raygun and app_prototype READMEs.
* Use $PORT to set the server port for Heroku compatibility, with default set in .env.
* .ruby-version instead of .rbenv-version (as recommended by rbenv).
* Add a unique database constraint on users.email.

## 0.0.16 [2013-01-04]

* Improved authorization rules so that users can't delete themselves and non-admin can't access users controller :new.

## 0.0.15 [2012-12-26]

* Handle cases where raygun is given a name with dashes (e.g wonder-pets).
* Replace all instances of app_prototype with the real app name.

## 0.0.14 [2012-12-26]

* Basic usage information.
* Added guard-livereload to Guardfile.
* Better specs for auth flows (register, password reset, sign in) (~98% coverage).
* Use the new rspec expect(...).to syntax ([more info](http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax)).
* Hardcode 1.9.3-p327 so that app_prototype is executable without futzing.
* Consistent hostnames across environments.
* Use mailcatcher when it's running locally ([more info](http://www.mikeperham.com/2012/12/09/12-gems-of-christmas-4-mailcatcher-and-mail_view/)).
