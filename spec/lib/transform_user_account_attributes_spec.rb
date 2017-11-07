require 'rails_helper'

describe 'transform user account attributes' do

  it 'should return an array of verify compliant attributes' do

    form = OnboardingForm.new({
        environment_access: 'Integration access request',
        service_entity_id: 'https://example.com',
        matching_service_entity_id: 'https://example.com/msa',
        matching_service_url: 'https://example.com/msa',
        service_homepage_url: 'https://example.com/start',
        assertion_consumer_services_https_url: 'https://example.com/process-response',
        cycle3_attribute_name: 'cycle3attr',
        testing_devices_ips: 'some-ip-address',
        matching_service_adapter_ip: 'some-ip-address',
        signature_verification_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        signature_verification_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        user_account_creation_uri: 'https://example.com',
        user_account_first_name: true,
        user_account_middle_name: true,
        user_account_surname: true,
        user_account_dob: true,
        user_account_current_address: true,
        user_account_address_history: true,
        user_account_cycle_3: true,
        contact_details_phone: '012345 678 912',
        contact_details_message: 'Some text',
        service_display_name: 'Example service',
        other_ways_display_name: 'Example service',
        other_ways_complete_transaction: 'Some text',
        contact_details_name: 'username',
        contact_details_email: 'example@example.com',
        contact_details_service: 'Example service',
        contact_details_department: 'Example department',
        stub_idp_username: 'stub-idp-username',
        stub_idp_password: 'stup-idp-password'
    })


    expect(TransformUserAccountAttributes.new().get_array(form)).to eq([
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
        environment_access: 'Integration access request',
        service_entity_id: 'https://example.com',
        matching_service_entity_id: 'https://example.com/msa',
        matching_service_url: 'https://example.com/msa',
        service_homepage_url: 'https://example.com/start',
        assertion_consumer_services_https_url: 'https://example.com/process-response',
        cycle3_attribute_name: 'cycle3attr',
        testing_devices_ips: 'some-ip-address',
        matching_service_adapter_ip: 'some-ip-address',
        signature_verification_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        signature_verification_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        user_account_creation_uri: 'https://example.com',
        user_account_first_name: '0',
        user_account_middle_name: '0',
        user_account_surname: '0',
        user_account_dob: '0',
        user_account_current_address: '0',
        user_account_address_history: '0',
        user_account_cycle_3: '0',
        contact_details_phone: '012345 678 912',
        contact_details_message: 'Some text',
        service_display_name: 'Example service',
        other_ways_display_name: 'Example service',
        other_ways_complete_transaction: 'Some text',
        contact_details_name: 'username',
        contact_details_email: 'example@example.com',
        contact_details_service: 'Example service',
        contact_details_department: 'Example department',
        stub_idp_username: 'stub-idp-username',
        stub_idp_password: 'stup-idp-password'
    })


    expect(TransformUserAccountAttributes.new().get_array(form)).to eq([])
  end
end