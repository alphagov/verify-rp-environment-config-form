require 'zendesk_api'
require 'logger'

ZENDESK_CLIENT = ZendeskAPI::Client.new do |config|
  config.url = ENV.fetch('ZENDESK_BASE_URL')
  config.username = ENV.fetch('ZENDESK_USERNAME')
  config.token = ENV.fetch('ZENDESK_TOKEN')
  config.logger = Logger.new(STDOUT)
end
