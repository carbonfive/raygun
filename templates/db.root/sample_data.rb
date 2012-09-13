# Populate the database with a small set of realistic sample data so that as a developer/designer, you can use the
# application without having to create a bunch of stuff (or pull down production data).
#
# After running db:sample_data, a developer/designer should be able to fire up the app, sign in, browse data and see
# examples of practically anything (interesting) that can happen in the system.
#
# It's a good idea to build this up along with the features; when you build a feature, make sure you can demo it
# after running db:populate.
#
# Nothing in the file that is absolutely required to run the application (i.e. reference data) should be included here.
# That belongs in seeds.rb instead.

User.create! do |u|
  u.email    = 'user@example.com'
  u.name     = 'John Smith'
  u.password = 'password'
end.activate!

