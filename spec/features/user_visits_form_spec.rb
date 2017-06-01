require 'rails_helper'

RSpec.describe 'The start page', :type => :feature do

  ZENDESK_TICKETS_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}tickets.json"

  it 'should show the form' do
    visit '/'
    expect(page).to have_content 'Request access to an environment'
  end

  it 'should show errors for required fields' do
    visit '/'
    click_button 'Request access'
    expect(page).to have_content "Service entity ID can't be blank"
    expect(find_field(id: 'service_entity_id')).to match_selector('.form-control-error')
    expect(find_field(id: 'signature_verification_certificate_transaction')).to match_selector('.form-control-error')
    expect(find_field(id: 'other_ways_complete_transaction')).to match_selector('.form-control-error')
  end

  it 'should maintain the input values after validation fails' do
    visit '/'
    choose 'Production'
    fill_in('Service entity ID', with: 'some-bad-input')
    fill_in('Service signature validation certificate', with: 'some-bad-input')
    fill_in('Message (optional)', with: 'some-bad-input')
    check('First name')

    click_button 'Request access'

    expect(page).to have_checked_field('Production')
    expect(find_field(id: 'service_entity_id').value).to eq('some-bad-input')
    expect(find_field(id: 'signature_verification_certificate_transaction').value).to eq('some-bad-input')
    expect(find_field(id: 'contact_details_message').value).to eq('some-bad-input')
    expect(page).to have_checked_field('First name')
  end

  it 'should show confirmation page after a succesful form submit' do
    stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 201, :body => {"ticket":{"id": 123, "subject":"Test","comment":{"value":"some comment"}}}.to_json, :headers => {})
    submit_valid_form
    expect(page).to have_content('Your ticket has been created with the id #123')
  end

  it 'should show confirmation page after a succesful form submit even if there\'s no ticket id' do
    stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 201, :body => {"ticket":{"subject":"Test","comment":{"value":"some comment"}}}.to_json, :headers => {})
    submit_valid_form
    expect(page).to have_content('Your ticket has been created with the id #unknown')
  end

  it 'should show an error if zendesk submit fails' do
    stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 500)
    submit_valid_form
    expect(page).to have_content('There has been a problem')
  end

  def submit_valid_form
    visit '/'
    fill_in('Service entity ID', with: 'http://example.com')
    fill_in('Matching service entity ID', with: 'http://example.com/msa')
    fill_in('Matching service URL', with: 'http://example.com/msa')
    fill_in('Service start page URL', with: 'http://example.com')
    fill_in('Assertion consumer services HTTPS URL', with: 'http://example.com')

    fill_in 'Service signature validation certificate', with: GOOD_CERT
    fill_in 'Matching service signature validation certificate', with: GOOD_CERT
    fill_in 'Service encryption certificate', with: GOOD_CERT
    fill_in 'Matching service encryption certificate', with: GOOD_CERT

    fill_in 'Matching service user account creation URL', with: 'http://example.com/msa/create-account'
    fill_in 'IP address of the Matching Service Adapter (MSA)', with: 'some IP address'
    fill_in 'IP addresses of the devices used for testing', with: 'some IP address'
    fill_in 'Service display name', with: 'something'
    fill_in 'Other ways to... display name', with: 'something'
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
