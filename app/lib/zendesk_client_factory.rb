class ZendeskClientFactory

  @@client

  def self.create
    @@client ||= ZendeskClient.new(
        ENV.fetch('ZENDESK_BASE_URL'),
        ENV.fetch('ZENDESK_TOKEN'),
        ENV.fetch('ZENDESK_USERNAME'))
  end

end