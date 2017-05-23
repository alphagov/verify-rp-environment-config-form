
require 'rails_helper'

RSpec.describe 'The start page', :type => :feature do

  it 'should show the form' do
    visit '/'
    expect(page).to have_content 'Request access to an environment'
  end

  it 'should show errors for required fields' do
    visit '/'
    click_button 'Request access'
    expect(page).to have_content "Service entity ID can't be blank"
    expect(find_field(id: 'service_entity_id')).to match_selector('.form-control-error')
    expect(find_field(id: 'matching_service_entity_id')).to match_selector('.form-control-error')
    expect(find_field(id: 'matching_service_url')).to match_selector('.form-control-error')
    expect(find_field(id: 'service_homepage_url')).to match_selector('.form-control-error')
    expect(find_field(id: 'assertion_consumer_services_https_url')).to match_selector('.form-control-error')
    expect(find_field(id: 'signature_verification_certificate_transaction')).to match_selector('.form-control-error')
    expect(find_field(id: 'signature_verification_certificate_match')).to match_selector('.form-control-error')
    expect(find_field(id: 'encryption_certificate_transaction')).to match_selector('.form-control-error')
    expect(find_field(id: 'encryption_certificate_match')).to match_selector('.form-control-error')
    expect(find_field(id: 'service_display_name')).to match_selector('.form-control-error')
    expect(find_field(id: 'other_ways_display_name')).to match_selector('.form-control-error')
    expect(find_field(id: 'other_ways_complete_transaction')).to match_selector('.form-control-error')
    expect(find_field(id: 'contact_details_name')).to match_selector('.form-control-error')
    expect(find_field(id: 'contact_details_email')).to match_selector('.form-control-error')
    expect(find_field(id: 'contact_details_service')).to match_selector('.form-control-error')
    expect(find_field(id: 'contact_details_department')).to match_selector('.form-control-error')

    expect(page).to have_content "Matching service entity ID can't be blank"
    expect(page).to have_content "Matching service URL can't be blank"
    expect(page).to have_content "Service start page URL can't be blank"
    expect(page).to have_content "Assertion consumer services HTTPS URL can't be blank"
    expect(page).to have_content "Service display name can't be blank"
    expect(page).to have_content "Other ways to... display name can't be blank"
  end

  it 'should show errors for urls' do
    visit '/'
    fill_in('Service entity ID', with: 'not-a-url')
    fill_in('Matching service entity ID', with: 'not-a-url')
    fill_in('Matching service URL', with: 'not-a-url')
    fill_in('Service start page URL', with: 'not-a-url')
    fill_in('Assertion consumer services HTTPS URL', with: 'not-a-url')
    fill_in('Matching service user account creation URL', with: 'not-a-url')

    click_button 'Request access'

    expect(page).to have_content "Service entity ID must be a url"
    expect(page).to have_content "Matching service entity ID must be a url"
    expect(page).to have_content "Matching service URL must be a url"
    expect(page).to have_content "Service start page URL must be a url"
    expect(page).to have_content "Assertion consumer services HTTPS URL must be a url"
    expect(page).to have_content "Matching service user account creation URL must be a url"

  end

  it 'should show error when input for service entity id and matching service entity id are equal' do
    visit '/'
    fill_in('Service entity ID', with: 'http://example.com')
    fill_in('Matching service entity ID', with: 'http://example.com')

    click_button 'Request access'

    expect(page).to have_content "Entity IDs need to be different"
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

  it 'should validate certificate correctness' do
    visit '/'
    fill_in 'Service signature validation certificate', with: 'malformed-certificate'
    fill_in 'Matching service signature validation certificate', with: 'malformed-certificate'
    fill_in 'Service encryption certificate', with: 'malformed-certificate'
    fill_in 'Matching service encryption certificate', with: 'malformed-certificate'

    click_button 'Request access'

    expect(page).to have_content('Service signature validation certificate is malformed')
    expect(page).to have_content('Matching service signature validation certificate is malformed')
    expect(page).to have_content('Service encryption certificate is malformed')
    expect(page).to have_content('Matching service encryption certificate is malformed')
  end

end