# verify-rp-onboarding-form

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

