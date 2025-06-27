#!/bin/bash

set -e
echo "Delaying startup to give Kamal time to wait..."
sleep 10
echo "🔍 Checking if the database exists..."
if ! bundle exec rails db:exists >/dev/null 2>&1; then
  echo "⚠️ Database does not exist. Creating the database..."
  bundle exec rails db:create
  echo "✅ Database created"
else
  echo "✅ Database already exists"
fi

echo "🔄 Running database migrations..."
bundle exec rails db:migrate
echo "✅ Migrations are all up to date"

echo "🚀 Starting Rails server..."
exec "$@"
