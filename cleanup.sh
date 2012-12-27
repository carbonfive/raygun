#!/bin/sh

git clean -df
git checkout app_prototype/config/routes.rb app_prototype/db/schema.rb

rm -rfv app_prototype/log/*
rm -rfv app_prototype/tmp/*
rm -rfv app_prototype/coverage
