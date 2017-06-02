# Make sure ZendeskClient can be initialized.
# ZendeskClientFactory will require env variables to be set in order to work.
# It will raise an error if something is missing
ZendeskClientFactory.create
