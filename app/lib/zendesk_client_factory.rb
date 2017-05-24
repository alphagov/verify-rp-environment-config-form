require 'zendesk_api'

class ZendeskClientFactory

  @@client

  def self.create
    @@client ||= ZendeskAPI::Client.new do |config|
      config.url = ENV.fetch('ZENDESK_URL')
      config.username = ENV.fetch('ZENDESK_USERNAME')
      config.token = ENV.fetch('ZENDESK_TOKEN')
    end
  end

end