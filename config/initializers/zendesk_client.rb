require 'zendesk_api'

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = ENV.fetch('ZENDESK_BASE_URL')
  config.username = ENV.fetch('ZENDESK_USERNAME')
  config.token = ENV.fetch('ZENDESK_TOKEN')
end

ZENDESK_GROUP_ID = ENV.fetch('ZENDESK_NEW_TICKET_GROUP_ID')
