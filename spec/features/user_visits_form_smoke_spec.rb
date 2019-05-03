require 'rails_helper'
require 'tempfile'

RSpec.describe 'The config page', :type => :feature, :smoke => true do
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
    visit 'https://verify-environment-access.cloudapps.digital'

    click_button 'Continue'

    click_button 'Continue'

    click_button 'Continue'

    fill_in 'Service provider entity ID', with: 'http://smoketestexample.com'
    fill_in 'Service start page URL', with: 'http://smoketestexample.com'
    fill_in 'Response URL', with: 'http://smoketestexample.com'
    fill_in 'Service display name', with: 'smoke test'
    fill_in 'Service display name for "Other ways to apply"', with: 'smoke test'
    fill_in 'Other ways to complete the transaction', with: 'smoke test'
    fill_in 'Service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Username', with: 'smoketest'
    fill_in 'Password', with: 'password'

    fill_in 'Name', with: 'smoketester'
    fill_in 'Email address', with: 'smoketester@example.com'
    fill_in 'Service', with: 'smoketest'
    fill_in 'Department or Agency', with: 'smoketest'

    click_button 'Request access'
  end
end
