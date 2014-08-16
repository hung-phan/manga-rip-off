#!/bin/bash
rake assets:precompile RAILS_ENV=production
git add .
git commit -m "Heroku assets compile"
git push heroku master
git rm -rf public/assets/
git add .
git commit -m "Remove assets for depvelopment"
git push
