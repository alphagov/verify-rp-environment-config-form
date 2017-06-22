require 'bcrypt'

class OnboardingForm
  include ActiveModel::Model

  ENVIRONMENT_ACCESS_INTEGRATION = 'integration-access-request'
  ENVIRONMENT_ACCESS_PRODUCTION = 'production-access-request'

  OPTIONAL_FIELDS = [
    :cycle3_attribute_name,
    :user_account_creation_uri,
    :user_account_first_name,
    :user_account_middle_name,
    :user_account_surname,
    :user_account_dob,
    :user_account_current_address,
    :user_account_cycle_3,
    :contact_details_phone,
    :contact_details_message,
    :stub_idp_username,
    :stub_idp_password,
    :testing_devices_ips
  ]

  REQUIRED_FIELDS = [
    :environment_access,
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
    :contact_details_department,
    :matching_service_adapter_ip
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
  URL_FIELDS.each {|field_name| validates field_name, format: { with: /\Ahttps?:\/\//, message: 'must be a url' }, allow_blank: true}

  validates :stub_idp_username, presence: true, if: :is_integration_access_form?
  validates :stub_idp_password, presence: true, length: { minimum: 8 }, if: :is_integration_access_form?
  validates :testing_devices_ips, presence: true, if: :is_integration_access_form?
  validates :contact_details_email, format: { with: /.+@.+/, message: 'is not properly formatted' }
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
        certificate = OpenSSL::X509::Certificate.new(self.send(certificate_field))
        if @environment_access == ENVIRONMENT_ACCESS_INTEGRATION && !certificate.issuer.to_s.include?('IDAP Relying Party Test CA')
          errors.add(certificate_field, 'Certificates for the integration environment must be issued by IDAP Relying Party Test CA')
        elsif @environment_access == ENVIRONMENT_ACCESS_PRODUCTION && !certificate.issuer.to_s.include?('IDAP Relying Party CA G2')
          errors.add(certificate_field, 'Certificates for the production environment must be issued by IDAP Relying Party CA G2')
        end
      rescue
        errors[certificate_field] << 'is malformed'
      end
    }
  end

  def is_integration_access_form?
    environment_access == ENVIRONMENT_ACCESS_INTEGRATION
  end

  def hashed_password
    @hashed_password ||= BCrypt::Password.create(stub_idp_password)
  end

end