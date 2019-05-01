require 'rails_helper'
require 'tempfile'


RSpec.describe 'The start page', :type => :feature do

  ZENDESK_TICKETS_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}tickets"
  ZENDESK_UPLOADS_URL = "#{ENV.fetch('ZENDESK_BASE_URL')}uploads"

  before(:all) do
    @cert_file = Tempfile.new('good-cert')
    @cert_file.write(GOOD_CERT_GOOD_ISSUER_INTEGRATION)
    @cert_file.close
  end

  after(:all) do
    @cert_file.unlink
  end

  context 'When visiting options pages' do
    before(:each) do
      visit '/'
      expect(page).to have_content 'Request access to an environment'
    end

    it 'should show the options start page' do
      expect(page).to have_content 'Select the environment you require'
      expect(page).to have_content 'Select the level of assurance'
    end

    it 'should go to next option page' do
      page.click_button('Continue')
      expect(page).to have_content 'Select your service provider'
    end
  end

  context 'When visiting the config page' do

    it 'should show the config form page with all sections' do
      create_options_session
      visit '/config'
      expect(page).to have_content 'Service configuration'
      expect(page).not_to have_selector '#reuse_service_entity_id'
      expect(page).to have_selector '#service_display_name'
      expect(page).to have_selector '#signature_verification_certificate_transaction'

      expect(page).to have_content 'Matching Service Adapter configuration'
      expect(page).to have_selector '#matching_service_entity_id'
      expect(page).to have_selector '#matching_service_url'
      expect(page).to have_selector '#signature_verification_certificate_match'

      expect(page).to have_content 'Manage your Integration environment test user data'
      expect(page).to have_content 'Your contact details'
    end

    it 'should show the correct fields when reusing service config' do
      create_options_session ({reuse_service_config: 'Yes'})
      visit '/config'
      expect(page).to have_content 'Service configuration'
      expect(page).to have_selector '#reuse_service_entity_id'
      expect(page).not_to have_selector '#service_display_name'
      expect(page).not_to have_selector '#signature_verification_certificate_transaction'

      expect(page).to have_content 'Matching Service Adapter configuration'
      expect(page).to have_selector '#matching_service_entity_id'
      expect(page).to have_selector '#matching_service_url'
      expect(page).to have_selector '#signature_verification_certificate_match'

      expect(page).to have_content 'Manage your Integration environment test user data'
      expect(page).to have_content 'Your contact details'
    end

    it 'should show the correct fields when reusing msa config' do
      create_options_session ({reuse_msa_config: 'Yes'})
      visit '/config'
      expect(page).to have_content 'Service configuration'
      expect(page).not_to have_selector '#reuse_service_entity_id'
      expect(page).to have_selector '#service_display_name'
      expect(page).to have_selector '#signature_verification_certificate_transaction'

      expect(page).to have_content 'Matching Service Adapter configuration'
      expect(page).to have_selector '#matching_service_entity_id'
      expect(page).not_to have_selector '#matching_service_url'
      expect(page).not_to have_selector '#signature_verification_certificate_match'

      expect(page).to have_content 'Manage your Integration environment test user data'
      expect(page).to have_content 'Your contact details'
    end

    it 'should hide the MSA config if not required' do
      create_options_session({:matching_service_adapter => 'None'})
      visit '/config'
      expect(page).to have_content 'Service configuration'
      expect(page).not_to have_content 'Matching Service Adapter configuration'
      expect(page).to have_content 'Manage your Integration environment test user data'
      expect(page).to have_content 'Your contact details'
    end

    it 'should hide the Integration config if not required' do
      create_options_session({:environment_access => OnboardingForm::ENVIRONMENT_ACCESS_PRODUCTION})
      visit '/config'
      expect(page).to have_content 'Service configuration'
      expect(page).to have_content 'Matching Service Adapter configuration'
      expect(page).not_to have_content 'Manage your Integration environment test user data'
      expect(page).to have_content 'Your contact details'
    end

    it 'should show errors for required fields' do
      create_options_session
      visit '/config'
      click_button 'Request access'
      expect(page).to have_content 'Service provider entity ID can\'t be blank'
      expect(page).to have_content 'Unfortunately the form does not seem to be valid.'
      expect(find_field(id: 'service_entity_id')).to match_selector('.form-control-error')
      expect(find_field(id: 'signature_verification_certificate_transaction')).to match_selector('.form-control-error')
      expect(find_field(id: 'other_ways_complete_transaction')).to match_selector('.form-control-error')
    end

    it 'should maintain the input values after validation fails' do
      create_options_session
      visit '/config'
      fill_in('Service provider entity ID', with: 'some-bad-input')
      fill_in('Service signature validation certificate', with: 'some-bad-input')
      fill_in('Any other information you would like to provide (optional)', with: 'some-bad-input')
      check('First name')

      click_button 'Request access'

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
      create_options_session
      submit_valid_form
      expect(page).to have_content('Your ticket has been created with the id #123456')
    end

    it 'should show an error if zendesk submit fails' do
      stub_request(:post, ZENDESK_TICKETS_URL).to_return(:status => 500)
      create_options_session
      submit_valid_form
      expect(page).to have_content('There has been a problem')
    end

    it 'should upload a file for certificate field' do
      create_options_session
      visit '/config'

      attach_file 'signature_verification_certificate_transaction-attachment', @cert_file.path
      attach_file 'signature_verification_certificate_match-attachment', @cert_file.path
      attach_file 'encryption_certificate_transaction-attachment', @cert_file.path
      attach_file 'encryption_certificate_match-attachment', @cert_file.path
      click_button 'Request access'

      expect(find_field(id: 'signature_verification_certificate_transaction').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION_FLAT)
      expect(find_field(id: 'signature_verification_certificate_match').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION_FLAT)
      expect(find_field(id: 'encryption_certificate_transaction').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION_FLAT)
      expect(find_field(id: 'encryption_certificate_match').value).to eq(GOOD_CERT_GOOD_ISSUER_INTEGRATION_FLAT)
    end
  end
  def submit_valid_form
    visit '/config'
    fill_in 'Service provider entity ID', with: 'http://example.com'
    fill_in 'Service start page URL', with: 'http://example.com/start'
    fill_in 'Response URL', with: 'http://example.com'
    fill_in 'Service display name', with: 'something'
    fill_in 'Service display name for "Other ways to apply"', with: 'something'
    fill_in 'Other ways to complete the transaction', with: 'something'
    fill_in 'Service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Matching Service Adapter entity ID', with: 'http://example.com/msa'
    fill_in 'Matching URL', with: 'http://example.com/msa'
    fill_in 'User account creation URL', with: 'http://example.com/msa/create-account'
    fill_in 'Matching service signature validation certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION
    fill_in 'Matching service encryption certificate', with: GOOD_CERT_GOOD_ISSUER_INTEGRATION

    fill_in 'Username', with: 'username'
    fill_in 'Password', with: 'password'

    fill_in 'Name', with: 'something'
    fill_in 'Email address', with: 'email@example.com'
    fill_in 'Service', with: 'something'
    fill_in 'Department or Agency', with: 'something'

    click_button 'Request access'
  end

  def create_options_session(overrides = {})
    options = {
        :environment_access => OnboardingForm::ENVIRONMENT_ACCESS_INTEGRATION,
        :level_of_assurance => 'LEVEL_1',
        :service_provider => 'VSP',
        :reuse_service_config => 'No',
        :matching_service_adapter => 'MSA',
        :reuse_msa_config => 'No'}.merge(overrides)
    page.set_rack_session(options: options)
  end
end
