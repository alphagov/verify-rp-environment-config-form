# verify-rp-onboarding-form

[![Build Status](https://api.travis-ci.org/alphagov/verify-rp-environment-config-form.svg?branch=master)](https://travis-ci.org/alphagov/verify-rp-environment-config-form)

A form for requesting configuration changes for integrating a Relying Party to GOV.UK Verify.

## Installing the application

Once you’ve cloned this then `bundle` will install the requirements.

## Running the application

Prepare the application configuration:

```
cp .env-example .env
vim .env
```

You can run the application with:

```
bundle exec rails server
open localhost:3000
```

## Running the tests

`./pre-commit.sh`

## Running the smoke test

`user_visits_form_smoke_spec.rb` will run an end to end acceptance test, creating a real ticket in Zendesk when this test submits the config form.

The test is run within Docker. This allows us to create an environment that includes the dependencies required by Selenium to run on our Jenkins setup. The Jenkins job that runs the smoke test is triggered every 5 minutes and after this application is deployed.

The smoke test has been filtered out of the main test run (`bundle exec rspec spec`) via a `smoke` filter.

To run the smoke test, use: `./smoke-test.sh`.
