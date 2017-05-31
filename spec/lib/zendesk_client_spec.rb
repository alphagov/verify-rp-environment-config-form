require 'rails_helper'

describe ZendeskClient do

  it 'should send create ticket request' do
    stub_request(:post, 'https://example.com:443/api/v2/tickets.json').to_return(:status => 201, :body => {ticket: {id: 123, subject: 'Test', comment: {value: 'some comment'}}}.to_json)
    zendesk_client = ZendeskClient.new('example.com', 'someAPIToken')
    expect(zendesk_client.create_ticket({subject: 'Test', comment: {value: 'some comment'}})).to eq({'ticket' => {'id'=> 123, 'subject'=> 'Test', 'comment'=> {'value'=> 'some comment'}}})
  end

  it 'should raise when an error occurs' do
    stub_request(:post, 'https://example.com:443/api/v2/tickets.json').to_return(:status => 500)
    zendesk_client = ZendeskClient.new('example.com', 'someAPIToken')
    expect(Proc.new {
      zendesk_client.create_ticket({})
    }).to raise_error(RuntimeError)
  end

end
