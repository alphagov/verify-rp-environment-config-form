class OnboardingForm
  include ActiveModel::Model

  attr_accessor :service_entity_id, :matching_service_entity_id, :matching_service_url, :service_homepage_url, :assertion_consumer_services_https_url,
                :signature_verification_certificate_transaction, :signature_verification_certificate_match, :encryption_certificate_transaction,
                :encryption_certificate_match, :cycle3_attribute_name, :user_account_creation_uri, :user_account_first_name, :user_account_middle_name,
                :user_account_surname, :user_account_dob, :user_account_current_address, :user_account_cycle_3, :service_display_name,
                :other_ways_display_name, :other_ways_complete_transaction, :contact_details_name, :contact_details_email, :contact_details_phone,
                :contact_details_message, :contact_details_service, :contact_details_department

  def initialize(hash)
    @service_entity_id = hash['service_entity_id']
    @matching_service_entity_id = hash['matching_service_entity_id']
    @matching_service_url = hash['matching_service_url']
    @service_homepage_url = hash['service_homepage_url']
    @assertion_consumer_services_https_url = hash['assertion_consumer_services_https_url']
    @signature_verification_certificate_transaction = hash['signature_verification_certificate_transaction']
    @signature_verification_certificate_match = hash['signature_verification_certificate_match']
    @encryption_certificate_transaction = hash['encryption_certificate_transaction']
    @encryption_certificate_match = hash['encryption_certificate_match']
    @cycle3_attribute_name = hash['cycle3_attribute_name']
    @user_account_creation_uri = hash['user_account_creation_uri']
    @user_account_first_name = hash['user_account_first_name']
    @user_account_middle_name = hash['user_account_middle_name']
    @user_account_surname = hash['user_account_surname']
    @user_account_dob = hash['user_account_dob']
    @user_account_current_address = hash['user_account_current_address']
    @user_account_cycle_3 = hash['user_account_cycle_3']
    @service_display_name = hash['service_display_name']
    @other_ways_display_name = hash['other_ways_display_name']
    @other_ways_complete_transaction = hash['other_ways_complete_transaction']
    @contact_details_name = hash['contact_details_name']
    @contact_details_email = hash['contact_details_email']
    @contact_details_phone = hash['contact_details_phone']
    @contact_details_message = hash['contact_details_message']
    @contact_details_service = hash['contact_details_service']
    @contact_details_department = hash['contact_details_department']
  end

end