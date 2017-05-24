require 'rails_helper'

describe OnboardingForm do

  context 'validate' do

    it 'should return true when there are no validation errors' do
      form = OnboardingForm.new({
        :service_entity_id => 'http://example.com',
        :matching_service_entity_id => 'http://example.com/msa',
        :matching_service_url => 'http://example.com/msa',
        :service_homepage_url => 'http://example.com',
        :assertion_consumer_services_https_url => 'http://example.com',
        :signature_verification_certificate_transaction => GOOD_CERT,
        :signature_verification_certificate_match => GOOD_CERT,
        :encryption_certificate_transaction => GOOD_CERT,
        :encryption_certificate_match => GOOD_CERT,
        :service_display_name => 'something',
        :other_ways_display_name => 'something',
        :other_ways_complete_transaction => 'something',
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

  end

end