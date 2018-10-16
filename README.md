# verify-rp-onboarding-form

A form for requesting configuration changes for integrating a Relying Party to GOV.UK Verify.

## Installing the application

Once you’ve cloned this then `bundle` will install the requirements.

## Running the application

The application makes use of environment variables for specifying certain configurable parameters.
You can set these by creating a file named `.env` and defining any environment variables within. 
The file `.env-example` lists all the required environment variables with example values - simply 
copy it and change the values.

```bash
cp .env-example .env
vim .env
```

Once the required environment variables have been defined, you can run the application with:

```bash
bundle exec rails server
open localhost:3000
```

#### Environment variables

| Variable name | Description |
| ------------- | ----------- |
| `ZENDESK_BASE_URL` | Base URL of Zendesk API (e.g. https://<your-org>.zendesk.com/api/v2/) |
| `ZENDESK_TOKEN` | Zendesk token is require for making calls to its API. A Zendesk admin can 
generate one if needed. |
| `ZENDESK_USERNAME` | Username (usually an email address) of the account to which the token 
belongs. |
| `ZENDESK_NEW_TICKET_GROUP_ID` | ID of the group in Zendesk to which a newly created ticket will
be assigned. |


## Running the tests

`./pre-commit.sh`

## Running the smoke test

`user_visits_form_smoke_spec.rb` will run an end to end acceptance test, creating a real ticket in Zendesk when this test submits the config form.

The test is run within Docker. This allows us to create an environment that includes the dependencies required by Selenium to run on our Jenkins setup. The Jenkins job that runs the smoke test is triggered every 5 minutes and after this application is deployed.

The smoke test has been filtered out of the main test run (`bundle exec rspec spec`) via a `smoke` filter.

To run the smoke test, use: `./smoke-test.sh`.
