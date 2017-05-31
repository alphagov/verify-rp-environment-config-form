require 'net/http'
require 'uri'
require 'json'

class ZendeskClient

  def initialize(zendesk_url, zendesk_api_token, zendesk_username)
    @zendesk_url = URI(zendesk_url)
    @zendesk_api_token = zendesk_api_token
    @zendesk_username = zendesk_username
  end

  def create_ticket(ticket_attributes)

    req = Net::HTTP::Post.new(@zendesk_url + 'tickets.json')
    req.basic_auth(@zendesk_username + '/token', @zendesk_api_token)
    req.content_type = 'application/json'
    req.body = ticket_attributes.to_json

    response = Net::HTTP.start(@zendesk_url.hostname, @zendesk_url.port, use_ssl: @zendesk_url.scheme == 'https') {|http|
      http.request(req)
    }

    if response.code == '201'
      JSON.parse(response.body)
    else
      Rails.logger.error('Got zendesk response with code: ' + response.code)
      Rails.logger.error('Response was: ' + response.body.inspect)
      raise RuntimeError.new(response.body)
    end

  end

end