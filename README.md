# ARCHIVED

* Ruby version: 2.6.3
* Node version: 10.16.0 (v12 will break yarn)
* Running Locally:
  * `heroku config:get -s > .env` from the staging env.
  * Delete all variables that start with `HEROKU_`
  * Set `RACK_ENV`, `RAILS_ENV`, and `NODE_ENV` to development
  * `heroku local web` to startup.
