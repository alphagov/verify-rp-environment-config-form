require 'rails_helper'
require 'bcrypt'

describe OnboardingForm do

  context 'validate' do

    def create_default_options
      OnboardingOptions.new({
                                :environment_access => OnboardingForm::ENVIRONMENT_ACCESS_INTEGRATION,
                                :level_of_assurance => 'LEVEL_1',
                                :service_provider => 'VSP',
                                :reuse_service_config => 'No',
                                :matching_service_adapter => 'MSA',
                                :reuse_msa_config => 'No'})
    end

    def create_valid_form
      OnboardingForm.new({
          :options => create_default_options,
          :service_entity_id => 'http://example.com',
          :matching_service_entity_id => 'http://example.com/msa',
          :matching_service_url => 'http://example.com/msa',
          :service_homepage_url => 'http://example.com',
          :assertion_consumer_services_https_url => 'http://example.com',
          :signature_verification_certificate_transaction => GOOD_CERT_GOOD_ISSUER_INTEGRATION,
          :signature_verification_certificate_match => GOOD_CERT_GOOD_ISSUER_INTEGRATION,
          :encryption_certificate_transaction => GOOD_CERT_GOOD_ISSUER_INTEGRATION,
          :encryption_certificate_match => GOOD_CERT_GOOD_ISSUER_INTEGRATION,
          :service_display_name => 'something',
          :other_ways_display_name => 'something',
          :other_ways_complete_transaction => 'something',
          :stub_idp_username => 'something',
          :stub_idp_password => 'password',
          :contact_details_name => 'something',
          :contact_details_email => 'something@email.com',
          :contact_details_service => 'something',
          :contact_details_department => 'something',
          :user_account_creation_uri => 'http://example.com'
      })
    end

    it 'should return true when there are no validation errors' do
      form = create_valid_form()

      expect(form).to be_valid
    end

    it 'should require required fields' do
      form = OnboardingForm.new({options: create_default_options})
      form.valid?
      expect(form.errors['service_entity_id']).to include("can't be blank")
      expect(form.errors['matching_service_entity_id']).to include("can't be blank")
      expect(form.errors['matching_service_url']).to include("can't be blank")
      expect(form.errors['service_homepage_url']).to include("can't be blank")
      expect(form.errors['assertion_consumer_services_https_url']).to include("can't be blank")
      expect(form.errors['signature_verification_certificate_transaction']).to include("can't be blank")
      expect(form.errors['signature_verification_certificate_match']).to include("can't be blank")
      expect(form.errors['encryption_certificate_transaction']).to include("can't be blank")
      expect(form.errors['encryption_certificate_match']).to include("can't be blank")
      expect(form.errors['service_display_name']).to include("can't be blank")
      expect(form.errors['other_ways_display_name']).to include("can't be blank")
      expect(form.errors['other_ways_complete_transaction']).to include("can't be blank")
      expect(form.errors['stub_idp_username']).to include("can't be blank")
      expect(form.errors['stub_idp_password']).to include("can't be blank")
      expect(form.errors['contact_details_name']).to include("can't be blank")
      expect(form.errors['contact_details_email']).to include("can't be blank")
      expect(form.errors['contact_details_service']).to include("can't be blank")
      expect(form.errors['contact_details_department']).to include("can't be blank")
    end

    it 'should require urls to be urls' do
      form = OnboardingForm.new({
          options: create_default_options,
          service_entity_id: 'not-a-url',
          matching_service_entity_id: 'not-a-url',
          matching_service_url: 'not-a-url',
          service_homepage_url: 'not-a-url',
          assertion_consumer_services_https_url: 'not-a-url',
          user_account_creation_uri: 'not-a-url',
      })
      form.valid?
      expect(form.errors['service_entity_id']).to include('must be a url')
      expect(form.errors['matching_service_entity_id']).to include('must be a url')
      expect(form.errors['matching_service_url']).to include('must be a url')
      expect(form.errors['service_homepage_url']).to include('must be a url')
      expect(form.errors['assertion_consumer_services_https_url']).to include('must be a url')
      expect(form.errors['user_account_creation_uri']).to include('must be a url')
    end

    it 'should not require username and password on production environment' do
      options = create_default_options
      options.environment_access = OnboardingForm::ENVIRONMENT_ACCESS_PRODUCTION
      form = OnboardingForm.new({options: options})
      form.valid?
      expect(form.errors['stub_idp_password']).to_not include("can't be blank")
      expect(form.errors['stub_idp_username']).to_not include("can't be blank")
    end

    it 'should validate certificate correctness' do
      form = OnboardingForm.new({
          :options => create_default_options,
          :signature_verification_certificate_transaction => 'malformed-cert',
          :signature_verification_certificate_match => 'malformed-cert',
          :encryption_certificate_transaction => 'malformed-cert',
          :encryption_certificate_match => 'malformed-cert',
      })
      form.valid?
      expect(form.errors['signature_verification_certificate_transaction']).to include("is malformed")
      expect(form.errors['signature_verification_certificate_match']).to include("is malformed")
      expect(form.errors['encryption_certificate_transaction']).to include("is malformed")
      expect(form.errors['encryption_certificate_match']).to include("is malformed")
    end

    it 'should allow self signed certificates for Integration' do
      form = create_valid_form()
      form.signature_verification_certificate_transaction = GOOD_CERT_SELF_SIGNED
      form.signature_verification_certificate_match = GOOD_CERT_SELF_SIGNED
      form.encryption_certificate_transaction = GOOD_CERT_SELF_SIGNED
      form.encryption_certificate_match = GOOD_CERT_SELF_SIGNED

      expect(form).to be_valid
    end

    it 'should allow self signed certificates for Production' do
      form = create_valid_form()
      form.signature_verification_certificate_transaction = GOOD_CERT_SELF_SIGNED
      form.signature_verification_certificate_match = GOOD_CERT_SELF_SIGNED
      form.encryption_certificate_transaction = GOOD_CERT_SELF_SIGNED
      form.encryption_certificate_match = GOOD_CERT_SELF_SIGNED
      form.options.environment_access = OnboardingForm::ENVIRONMENT_ACCESS_PRODUCTION

      expect(form).to be_valid
    end

    it 'should require service entity id and matching service entity id to be different' do
      form = OnboardingForm.new({
          options: create_default_options,
          service_entity_id: 'foo',
          matching_service_entity_id: 'foo',
      })
      form.valid?
      expect(form.errors['matching_service_entity_id']).to include('needs to be different from the Verify service entity ID')
    end

    it 'should require at least 8 chars on password' do
      form = OnboardingForm.new({
          options: create_default_options,
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

  context 'user account attributes' do

    it 'should return an array of verify compliant attributes' do

      form = OnboardingForm.new({
          user_account_first_name: '1',
          user_account_middle_name: '1',
          user_account_surname: '1',
          user_account_dob: '1',
          user_account_current_address: '1',
          user_account_address_history: '1',
          user_account_cycle_3: '1',
      })

      expect(form.get_user_account_attributes_array).to eq([
          'FIRST_NAME',
          'FIRST_NAME_VERIFIED',
          'MIDDLE_NAME',
          'MIDDLE_NAME_VERIFIED',
          'SURNAME',
          'SURNAME_VERIFIED',
          'DATE_OF_BIRTH',
          'DATE_OF_BIRTH_VERIFIED',
          'CURRENT_ADDRESS',
          'CURRENT_ADDRESS_VERIFIED',
          'ADDRESS_HISTORY',
          'CYCLE_3'
      ])
    end

    it 'should return an array of no attributes when none are selected' do

      form = OnboardingForm.new({
          user_account_first_name: '0',
          user_account_middle_name: '0',
          user_account_surname: '0',
          user_account_dob: '0',
          user_account_current_address: '0',
          user_account_address_history: '0',
          user_account_cycle_3: '0',
      })

      expect(form.get_user_account_attributes_array).to eq([])
    end

  end

end
