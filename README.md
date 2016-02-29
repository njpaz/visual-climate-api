# Visual Climate API

The API for Visual Climate. First, follow the instructions in the [Visual Climate](https://github.com/njpaz/visual-climate) repo's README, then continue with the instructions below.

## Prerequisites

You will need the following things properly installed on your computer.

* All of the prerequisites in the [other Visual Climate repo](https://github.com/njpaz/visual-climate), plus:
* Ruby >= 2.2.3
* Rails 4.2.5
* PostgreSQL

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `bundle install`
* `mv config/secrets.yml.example config/secrets.yml`
* `rake secret` and add the result to the `secret_key_base` in `secrets.yml`
* `rake db:setup`

## Important!

If you want to run the app just to see the chart in action, you can run `rake initial:seed` and it'll populate the database with dummy data. However, if you want to run the sync, you will need to grab an API key from the [API's Request Web Service Token](https://www.ncdc.noaa.gov/cdo-web/token) page and add it to the `secrets.yml` under `NOAA_API_KEY`. Please note that the API is restricted to 1000 calls/day, with up to 1000 records per call.

## Running / Development

* `rails s`
* `ember server --proxy` in the [Ember repo](https://github.com/njpaz/visual-climate)

## Running Tests

* `rspec`

## Deploying

* `cap production deploy`
