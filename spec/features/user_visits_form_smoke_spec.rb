require 'rails_helper'
require 'tempfile'

RSpec.describe 'The start page', :type => :feature, :smoke => true do
  before(:all) do
    @cert_file = Tempfile.new('good-cert')
    @cert_file.write(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    @cert_file.close
  end

  after(:all) do
    @cert_file.unlink
  end

  # Instructions for running this spec have been documented in the README.
  it 'should submit form with real requests', :js => true do
    WebMock.allow_net_connect!

    submit_valid_form

    expect(page).to have_selector(:css, "h1", text: "Your request has been submitted", wait: 5)
    expect(page).to have_content('Your ticket has been created')
    expect(current_path).to eq '/submit'
  end


  def submit_valid_form
    visit 'https://verify-environment-access.cloudapps.digital/'

    fill_in('Verify service entity ID', with: 'http://smoketestexample.com')
    fill_in('Matching Service Adapter entity ID', with: 'http://smoketestexample.com/msa')
    fill_in('Matching Service Adapter: matching URL', with: 'http://smoketestexample.com/msa')
    fill_in('Service start page URL', with: 'http://smoketestexample.com')
    fill_in('Verify SAML response URL', with: 'http://smoketestexample.com')

    fill_in 'Service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Matching service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Matching service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Matching Service Adapter: User account creation URL', with: 'http://example.com/msa/create-account'
    fill_in 'Verify service display name', with: 'smoke test'
    fill_in 'Other ways to apply display name', with: 'smoke test'
    fill_in 'Other ways to complete the transaction', with: 'smoke test'

    fill_in 'Username', with: 'smoketest'
    fill_in 'Password', with: 'password'

    fill_in 'Name', with: 'smoketest'
    fill_in 'Email address', with: 'email@example.com'
    fill_in 'Service', with: 'smoketest'
    fill_in 'Department or Agency', with: 'smoketest'

    click_button 'Request access'
  end
end
