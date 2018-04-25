require 'zendesk_api'

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = ENV.fetch('ZENDESK_BASE_URL')
  config.username = ENV.fetch('ZENDESK_USERNAME')
  config.token = ENV.fetch('ZENDESK_TOKEN')
end

ZENDESK_GROUP_NAME = '3rd Line - Connecting to Verify'
