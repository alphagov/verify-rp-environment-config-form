class OnboardingForm
  include ActiveModel::Model

  OPTIONAL_FIELDS = [
    :environment_access,
    :cycle3_attribute_name,
    :user_account_creation_uri,
    :user_account_first_name,
    :user_account_middle_name,
    :user_account_surname,
    :user_account_dob,
    :user_account_current_address,
    :user_account_cycle_3,
    :contact_details_phone,
    :contact_details_message
  ]

  REQUIRED_FIELDS = [
    :service_entity_id,
    :matching_service_entity_id,
    :matching_service_url,
    :service_homepage_url,
    :assertion_consumer_services_https_url,
    :signature_verification_certificate_transaction,
    :signature_verification_certificate_match,
    :encryption_certificate_transaction,
    :encryption_certificate_match,
    :service_display_name,
    :other_ways_display_name,
    :other_ways_complete_transaction,
    :contact_details_name,
    :contact_details_email,
    :contact_details_service,
    :contact_details_department
  ]

  URL_FIELDS = [
      :service_entity_id,
      :matching_service_entity_id,
      :matching_service_url,
      :service_homepage_url,
      :assertion_consumer_services_https_url,
      :user_account_creation_uri
  ]

  CERTIFICATE_FIELDS = [
      :signature_verification_certificate_transaction,
      :signature_verification_certificate_match,
      :encryption_certificate_transaction,
      :encryption_certificate_match
  ]

  ALL_FIELDS = REQUIRED_FIELDS + OPTIONAL_FIELDS

  ALL_FIELDS.each {|field_name| attr_accessor field_name }
  REQUIRED_FIELDS.each {|field_name| validates field_name, :presence => true}
  URL_FIELDS.each {|field_name| validates field_name, format: { with: /\Ahttps?:\/\//, message: "must be a url" }}

  validate :validate_entity_ids_are_different, :validate_certificate_is_well_formed

  def initialize(attributes)
    super
  end

  def validate_entity_ids_are_different
    if (@service_entity_id == @matching_service_entity_id)
      errors['matching_service_entity_id'] << 'Entity IDs need to be different'
    end
  end

  def validate_certificate_is_well_formed
    CERTIFICATE_FIELDS.each {|certificate_field|
      begin
        OpenSSL::X509::Certificate.new(self.send(certificate_field))
      rescue
        errors[certificate_field] << 'is malformed'
      end
    }
  end

  def hashed_password
    "TODO"
  end

end