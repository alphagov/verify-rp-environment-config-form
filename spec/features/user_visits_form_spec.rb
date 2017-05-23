
require 'rails_helper'

RSpec.describe 'The start page', :type => :feature do

  it 'Visit start page and see form' do
    visit '/'
    expect(page).to have_content 'Request access to an environment'
  end

  it 'Visit start page and submit form' do
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

end