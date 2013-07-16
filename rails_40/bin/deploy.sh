#!/bin/sh -e

if [ $# -ne 1 ]; then
  echo 1>&2 "Usage: $0 <application name>"
  exit 1
fi

APP_NAME=$1

if [ -n "$CIRCLE_SHA1" ]; then
  SHA_TO_DEPLOY=$CIRCLE_SHA1
else
  echo "CIRCLE_SHA1 isn't set, deploying the latest revision."
  SHA_TO_DEPLOY=`git rev-parse HEAD`
fi

REMOTE_MISSING=$(git remote | grep heroku | wc -l)

if [ $REMOTE_MISSING -eq 0 ] ; then
  git remote add heroku git@heroku.com:$APP_NAME.git
fi

git fetch heroku

PREV_WORKERS=$(heroku ps --app $APP_NAME | grep "^worker." | wc -l | xargs)

PENDING_MIGRATIONS=$(git diff HEAD heroku/master --name-only -- db | wc -l | xargs)

echo "There are $PENDING_MIGRATIONS pending migrations."

# Migrations require downtime so enter maintenance mode
if [ $PENDING_MIGRATIONS -gt 0 ]; then
  heroku maintenance:on --app $APP_NAME

  # Make sure workers are not running during a migration
  heroku scale worker=0 --app $APP_NAME
fi

# Deploy code changes (and implicitly restart the app and any running workers)
git push -f heroku $SHA_TO_DEPLOY:refs/heads/master

# Run database migrations if needed and restart background workers once finished
if [ $PENDING_MIGRATIONS -gt 0 ]; then
  heroku run rake db:migrate db:seed --app $APP_NAME
  heroku scale worker=$PREV_WORKERS --app $APP_NAME
  heroku maintenance:off --app $APP_NAME
fi
