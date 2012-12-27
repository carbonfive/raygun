# Change Log

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
