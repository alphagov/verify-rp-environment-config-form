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
    # visit 'https://verify-environment-access.cloudapps.digital/config'
    visit 'http://localhost:3000/config'

    fill_in 'Service provider entity ID', with: 'http://example.com'
    fill_in 'Service start page URL', with: 'http://example.com/start'
    fill_in 'Response URL', with: 'http://example.com'
    fill_in 'Service display name', with: 'something'
    fill_in 'Service display name for "Other ways to apply"', with: 'something'
    fill_in 'Other ways to complete the transaction', with: 'something'
    fill_in 'Service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Username', with: 'username'
    fill_in 'Password', with: 'password'

    fill_in 'Name', with: 'something'
    fill_in 'Email address', with: 'email@example.com'
    fill_in 'Service', with: 'something'
    fill_in 'Department or Agency', with: 'something'

    click_button 'Request access'
  end
end
