require 'net/http'
require 'uri'
require 'json'

class ZendeskClient

  def initialize(zendesk_url, zendesk_api_token)
    @zendesk_url = zendesk_url
    @zendesk_api_token = zendesk_api_token
  end

  def create_ticket(ticket_attributes)

    http = Net::HTTP.new(@zendesk_url, 443)
    http.use_ssl = true

    response = http.request_post('/api/v2/tickets.json', ticket_attributes.to_json)

    if response.code == '201'
      JSON.parse(response.body)
    else
      raise RuntimeError.new(response.body)
    end

  end

end