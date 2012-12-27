#!/bin/sh

# All git ignored files: git ls-files --others -i --exclude-standard

git clean -df
git checkout app_prototype/config/routes.rb app_prototype/db/schema.rb

find . -name ".DS_Store" -exec rm -f {} \;

rm -rfv app_prototype/.DS_Store
rm -rfv app_prototype/log/*
rm -rfv app_prototype/tmp/*
rm -rfv app_prototype/coverage
