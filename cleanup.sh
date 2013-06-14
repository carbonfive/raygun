#!/bin/sh

# All git ignored files: git ls-files --others -i --exclude-standard

git clean -df
git checkout rails_32/config/routes.rb app_prototype/db/schema.rb

find . -name ".DS_Store" -exec rm -f {} \;

rm -rfv rails_32/.DS_Store
rm -rfv rails_32/log/*
rm -rfv rails_32/tmp/*
rm -rfv rails_32/coverage

rm -rfv rails_40/.DS_Store
rm -rfv rails_40/log/*
rm -rfv rails_40/tmp/*
rm -rfv rails_40/coverage
