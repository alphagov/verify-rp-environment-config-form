require 'bcrypt'

class OnboardingForm
  include ActiveModel::Model

  ENVIRONMENT_ACCESS_INTEGRATION = 'integration-access-request'
  ENVIRONMENT_ACCESS_PRODUCTION = 'production-access-request'

  CERTIFICATE_ISSUER_INTEGRATION = 'IDAP Relying Party Test CA'
  CERTIFICATE_ISSUER_PRODUCTION = 'IDAP Relying Party CA G2'

  OPTIONAL_FIELDS = [
    :cycle3_attribute_name,
    :user_account_creation_uri,
    :user_account_first_name,
    :user_account_middle_name,
    :user_account_surname,
    :user_account_dob,
    :user_account_current_address,
    :user_account_address_history,
    :user_account_cycle_3,
    :contact_details_phone,
    :contact_details_message,
    :stub_idp_username,
    :stub_idp_password
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
    :level_of_assurance,
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
  validates :contact_details_email, format: { with: /.+@.+/, message: 'is not properly formatted' }
  validate :validate_entity_ids_are_different, :validate_certificate

  def initialize(attributes)
    super
  end

  def validate_entity_ids_are_different
    if (@service_entity_id == @matching_service_entity_id)
      errors['matching_service_entity_id'] << 'needs to be different from the Verify service entity ID'
    end
  end

  def validate_certificate
    CERTIFICATE_FIELDS.each {|certificate_field|
      begin
        certificate = OpenSSL::X509::Certificate.new(self.send(certificate_field))
        if is_integration_access_form?
          validate_certificate_issuer(certificate, CERTIFICATE_ISSUER_INTEGRATION, certificate_field, 'integration')
        else
          validate_certificate_issuer(certificate, CERTIFICATE_ISSUER_PRODUCTION, certificate_field, 'production')
        end
      rescue
        errors[certificate_field] << 'is malformed'
      end
    }
  end

  def validate_certificate_issuer(certificate, issuer, certificate_field, environment)
    if !certificate.issuer.to_s.include?("CN=#{issuer}")
      errors.add(certificate_field, "Certificates for the #{environment} environment must be issued by #{issuer}")
    end
  end

  def is_integration_access_form?
    environment_access == ENVIRONMENT_ACCESS_INTEGRATION
  end

  def hashed_password
    @hashed_password ||= BCrypt::Password.create(stub_idp_password)
  end

  def get_user_account_attributes_array
    {
        user_account_first_name: ['FIRST_NAME', 'FIRST_NAME_VERIFIED'],
        user_account_middle_name: ['MIDDLE_NAME', 'MIDDLE_NAME_VERIFIED'],
        user_account_surname: ['SURNAME', 'SURNAME_VERIFIED'],
        user_account_dob: ['DATE_OF_BIRTH', 'DATE_OF_BIRTH_VERIFIED'],
        user_account_current_address: ['CURRENT_ADDRESS', 'CURRENT_ADDRESS_VERIFIED'],
        user_account_address_history: ['ADDRESS_HISTORY'],
        user_account_cycle_3: ['CYCLE_3']
    }.collect { |attribute_name, attr|
      self.send(attribute_name) != '0' ? attr : []
    }.flatten
  end

end
