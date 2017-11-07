require 'rails_helper'
require 'yaml'

describe 'ConfigFileService' do

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
    user_account_middle_name: '0',
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

  it 'should generate transaction config file' do

    test_transaction_filename = ConfigFileService.new(form).generate_transaction_config_file

    expect(YAML.load_file(test_transaction_filename)).to eq(YAML.load_file('./spec/test-rp-transaction-config.yml'))

    File.delete(test_transaction_filename)
  end

  it 'should generate msa config file' do
    test_msa_filename = ConfigFileService.new(form).generate_msa_config_file

    expect(YAML.load_file(test_msa_filename)).to eq(YAML.load_file('./spec/test-rp-msa-config.yml'))

    File.delete(test_msa_filename)
  end

  it 'should generate idp config file' do
    test_idp_filename = ConfigFileService.new(form).generate_stub_idp_file('test-stub-idp')

    expect(YAML.load_file(test_idp_filename)).to eq(YAML.load_file('./spec/test-stub-idp-config.yml'))

  end

end
