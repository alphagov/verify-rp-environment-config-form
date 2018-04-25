require 'rails_helper'
require 'tempfile'

RSpec.describe 'The start page', :type => :feature do

  ZENDESK_TICKETS_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}tickets"
  ZENDESK_UPLOADS_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}uploads"
  ZENDESK_SEARCH_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}search?query=type:group name:'#{ZENDESK_GROUP_NAME}'"

  before(:all) do
    @cert_file = Tempfile.new('good-cert')
    @cert_file.write(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    @cert_file.close
  end

  after(:all) do
    @cert_file.unlink
  end

  it 'should show the form' do
    visit '/'
    expect(page).to have_content 'Request access to an environment'
  end

  it 'should show errors for required fields' do
    visit '/'
    click_button 'Request access'
    expect(page).to have_content "Verify service entity ID can't be blank"
    expect(page).to have_content 'Unfortunately the form does not seem to be valid.'
    expect(find_field(id: 'service_entity_id')).to match_selector('.form-control-error')
    expect(find_field(id: 'signature_verification_certificate_transaction')).to match_selector('.form-control-error')
    expect(find_field(id: 'other_ways_complete_transaction')).to match_selector('.form-control-error')
  end

  it 'should maintain the input values after validation fails' do
    visit '/'
    choose 'Production'
    fill_in('Verify service entity ID', with: 'some-bad-input')
    fill_in('Service signature validation certificate', with: 'some-bad-input')
    fill_in('Any other information you would like to provide (optional)', with: 'some-bad-input')
    check('First name')

    click_button 'Request access'

    expect(page).to have_checked_field('Production')
    expect(find_field(id: 'service_entity_id').value).to eq('some-bad-input')
    expect(find_field(id: 'signature_verification_certificate_transaction').value).to eq('some-bad-input')
    expect(find_field(id: 'contact_details_message').value).to eq('some-bad-input')
    expect(page).to have_checked_field('First name')
  end

  it 'should show confirmation page after a succesful form submit' do
    ticket_number = 123456
    stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 201, :body => {"ticket":{"id":ticket_number}}.to_json, :headers => { "Content-Type": "application/json" })
    stub_request(:post, ZENDESK_UPLOADS_URL).to_return(:status => 201, :body => {"upload":{"token":ticket_number}}.to_json, :headers => { "Content-Type": "text/plain" })
    stub_request(:put, "#{ZENDESK_TICKETS_URL}/#{ticket_number}").to_return(:status => 200, :body => {"ticket":{"id":ticket_number}}.to_json, :headers => { "Content-Type": "application/json" })

    stub_request(:get, ZENDESK_SEARCH_URL).to_return(:status => 200,
                                                     :body => {"results": [{"id":360000257114 }]}.to_json,
                                                     :headers => { "Content-Type": "application/json" })

    submit_valid_form
    expect(page).to have_content('Your ticket has been created with the id #123456')
  end

  it 'should show an error if zendesk submit fails' do
    stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 500)
    submit_valid_form
    expect(page).to have_content('There has been a problem')
  end

  it 'should upload a file for certificate field' do
    visit '/'

    attach_file 'signature_verification_certificate_transaction-attachment', @cert_file.path
    attach_file 'signature_verification_certificate_match-attachment', @cert_file.path
    attach_file 'encryption_certificate_transaction-attachment', @cert_file.path
    attach_file 'encryption_certificate_match-attachment', @cert_file.path
    click_button 'Request access'

    expect(find_field(id: 'signature_verification_certificate_transaction').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    expect(find_field(id: 'signature_verification_certificate_match').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    expect(find_field(id: 'encryption_certificate_transaction').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    expect(find_field(id: 'encryption_certificate_match').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
  end

  def submit_valid_form
    visit '/'
    fill_in('Verify service entity ID', with: 'http://example.com')
    fill_in('Matching Service Adapter entity ID', with: 'http://example.com/msa')
    fill_in('Matching Service Adapter: matching URL', with: 'http://example.com/msa')
    fill_in('Service start page URL', with: 'http://example.com')
    fill_in('Verify SAML response URL', with: 'http://example.com')

    fill_in 'Service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Matching service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Matching service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Matching Service Adapter: User account creation URL', with: 'http://example.com/msa/create-account'
    fill_in 'Verify service display name', with: 'something'
    fill_in 'Other ways to apply display name', with: 'something'
    fill_in 'Other ways to complete the transaction', with: 'something'

    fill_in 'Username', with: 'username'
    fill_in 'Password', with: 'password'

    fill_in 'Name', with: 'something'
    fill_in 'Email address', with: 'email@example.com'
    fill_in 'Service', with: 'something'
    fill_in 'Department or Agency', with: 'something'

    click_button 'Request access'
  end
end
