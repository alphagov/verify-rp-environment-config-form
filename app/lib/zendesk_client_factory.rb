require 'zendesk_api'

class ZendeskClientFactory

  @@client

  def self.create
    @@client ||= ZendeskClient.new(ENV.fetch('ZENDESK_HOSTNAME'), ENV.fetch('ZENDESK_TOKEN'))
  end

end