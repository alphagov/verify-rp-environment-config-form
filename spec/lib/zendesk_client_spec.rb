require 'rails_helper'

describe ZendeskClient do

  it 'should send create ticket request' do
    stub_request(:post, 'https://example.com/api/v2/tickets.json').
        with(headers: {Authorization: 'Basic c29tZVVzZXJuYW1lQGV4YW1wbGUuY29tL3Rva2VuOnNvbWVBUElUb2tlbg==', 'Content-Type' => 'application/json'}).
        to_return(:status => 201, :body => {ticket: {id: 123, subject: 'Test', comment: {body: 'some comment'}}}.to_json)

    zendesk_client = ZendeskClient.new('https://example.com/api/v2/', 'someAPIToken', 'someUsername@example.com')

    expect(zendesk_client.create_ticket({subject: 'Test', comment: {body: 'some comment'}})).to eq({'ticket' => {'id'=> 123, 'subject'=> 'Test', 'comment'=> {'body'=> 'some comment'}}})
  end

  it 'should raise when an error occurs' do
    stub_request(:post, 'https://example.com/api/v2/tickets.json').to_return(:status => 500)
    zendesk_client = ZendeskClient.new('https://example.com/api/v2/', 'someAPIToken', 'someUsername@example.com')
    expect(Proc.new {
      zendesk_client.create_ticket({})
    }).to raise_error(RuntimeError)
  end

end
