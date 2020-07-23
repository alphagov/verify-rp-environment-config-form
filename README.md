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


## Running the tests

`./pre-commit.sh`

## Running the smoke test

`user_visits_form_smoke_spec.rb` will run an end to end acceptance test, creating a real ticket in Zendesk when this test submits the config form.

The test is run within Docker. This allows us to create an environment that includes the dependencies required by Selenium to run on our CI/CD setup.

The smoke test has been filtered out of the main test run (`bundle exec rspec spec`) via a `smoke` filter.

To run the smoke test, use: `./smoke-test.sh`.


## Deploying

| Environment | App Name | PaaS Space Name |
| ------------- | ----------- | ----------- |
| Production | `verify-environment-access` | `docs` |
| Staging | `verify-environment-access-staging` | `docs-staging` |

Changes to this repository are continuously deployed to `staging` and `production` environments by the
[deploy-verify-rp-environment-config-form pipeline in
concourse](https://cd.gds-reliability.engineering/teams/verify/pipelines/deploy-verify-rp-environment-config-form)
on merge to master.

If you need to manually deploy changes you can follow the steps below.

The environment variables above currently need to be set manually before deployment:

```
cf login
```

Choose the `docs` space from the options provided, or target it manually:

```
cf target -s docs
```

To set an environment variable:

```
cf set-env verify-environment-access <ENV_VAR> <VALUE>
```

To see the current environment config for the app:

```
cf env verify-environment-access
```

If you only need to make changes to environment variables and you do not need to redeploy the app you can just restage it to pick up the changes:

```
cf restage verify-environment-access
```


## Debugging

The logging output from the Zendesk client is not very verbose. You can add the following to the Zendesk client config in `zendesk_client.rb`:

```
require 'logger'
config.logger = Logger.new(STDOUT)
```

This also logs out unredacted information for the form that is being submitted so do not check this in.

To run the smoke tests locally the you can change the url that the `spec/features/user_visits_form_smoke_spec.rb` is visiting to `http://host.docker.internal:3000/`. The Docker containers running the smoke tests then should make the requests to your local app.

To see the logs for the app on the PaaS:

```
cf logs verify-environment-access
```

The above will give you a real time tail of the logs.

```
cf logs verify-environment-access --recent
```

The above will output all the current log lines in the [Loggregator buffer](https://docs.cloudfoundry.org/loggregator/architecture.html) associated with the app.

If you need to ssh onto the container for any reason:

```
cf ssh verify-environment-access
```
