require 'rails_helper'
require 'bcrypt'

describe OnboardingForm do

  context 'validate' do

    it 'should return true when there are no validation errors' do
      form = OnboardingForm.new({
        :environment_access => OnboardingForm::ENVIRONMENT_ACCESS_INTEGRATION,
        :service_entity_id => 'http://example.com',
        :matching_service_entity_id => 'http://example.com/msa',
        :matching_service_url => 'http://example.com/msa',
        :matching_service_adapter_ip => 'something',
        :testing_devices_ips => 'something',
        :service_homepage_url => 'http://example.com',
        :assertion_consumer_services_https_url => 'http://example.com',
        :signature_verification_certificate_transaction => GOOD_CERT,
        :signature_verification_certificate_match => GOOD_CERT,
        :encryption_certificate_transaction => GOOD_CERT,
        :encryption_certificate_match => GOOD_CERT,
        :service_display_name => 'something',
        :other_ways_display_name => 'something',
        :other_ways_complete_transaction => 'something',
        :stub_idp_username => 'something',
        :stub_idp_password => 'password',
        :contact_details_name => 'something',
        :contact_details_email => 'something',
        :contact_details_service => 'something',
        :contact_details_department => 'something'   ,
        :user_account_creation_uri => 'http://example.com'
      })
      expect(form).to be_valid
    end

    it 'should return false when there are validation errors' do
      form = OnboardingForm.new({})
      expect(form).to_not be_valid
    end

    it 'should require username and password on integration environment' do
      form = OnboardingForm.new({ environment_access: OnboardingForm::ENVIRONMENT_ACCESS_INTEGRATION })
      form.valid?
      expect(form.errors['stub_idp_password']).to include("can't be blank")
      expect(form.errors['stub_idp_username']).to include("can't be blank")
    end

    it 'should require at least 8 chars on password' do
      form = OnboardingForm.new({
        environment_access: OnboardingForm::ENVIRONMENT_ACCESS_INTEGRATION,
        stub_idp_password: 'asdf'
      })
      form.valid?
      expect(form.errors['stub_idp_password']).to include("is too short (minimum is 8 characters)")
    end

  end

  context 'password hashing' do

    it 'should hash the password' do
      form = OnboardingForm.new({
        stub_idp_password: 'asdfasdf'
      })
      expect(form.hashed_password).to eq(form.stub_idp_password)
      expect(form.hashed_password).to be_a(BCrypt::Password)
    end

  end

end