require 'bcrypt'

class OnboardingForm
  include ActiveModel::Model
  include ActiveModel::Validations

  ENVIRONMENT_ACCESS_INTEGRATION = 'integration-access-request'
  ENVIRONMENT_ACCESS_PRODUCTION = 'production-access-request'

  CERTIFICATE_ISSUER_INTEGRATION = 'IDAP Relying Party Test CA'
  CERTIFICATE_ISSUER_PRODUCTION = 'IDAP Relying Party CA G2'

  ALL_FIELDS = [
      :options,
      :service_entity_id,
      :reuse_service_entity_id,
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

  CERTIFICATE_FIELDS = [
      :signature_verification_certificate_transaction,
      :signature_verification_certificate_match,
      :encryption_certificate_transaction,
      :encryption_certificate_match
  ]

  ALL_FIELDS.each {|field_name| attr_accessor field_name }

  validates_with ServiceValidator
  validates_with MSAValidator, if: Proc.new{|form| form.is_use_msa?}
  validates_with IntegrationValidator, if: Proc.new{|form| form.is_integration?}
  validates_with ContactValidator

  def initialize(attributes)
    super
  end

  def is_integration?
    options.environment_access == ENVIRONMENT_ACCESS_INTEGRATION
  end

  def is_vsp?
    options.service_provider == 'VSP'
  end

  def is_reuse_service_config?
    options.reuse_service_config == 'Yes'
  end

  def is_use_msa?
    options.matching_service_adapter == 'MSA'
  end

  def is_reuse_msa_config?
    options.reuse_msa_config == 'Yes'
  end

  def validate_entity_ids_are_different
    if (@service_entity_id == @matching_service_entity_id)
      errors['matching_service_entity_id'] << 'needs to be different from the Verify service entity ID'
    end
  end

  def validate_not_empty(field_name)
    if self.send(field_name).empty?
      errors.add(field_name, 'must not be empty')
    end
  end

  def validate_url(field_name)
    unless self.send(field_name)[/\Ahttps?:\/\//]
      errors.add(field_name, 'must be a url')
    end
  end

  def validate_email(field_name)
    unless self.send(field_name)[/.+@.+/]
      errors.add(field_name, 'is not properly formatted')
    end
  end

  def validate_strong_password(field_name)
    if self.send(field_name).length < 8
      errors.add(field_name, 'must be at least 8 characters')
    end
  end

  def validate_certificate(field_name)
    certificate = convert_value_to_x509_certificate(self.send(field_name))
    self.send("#{field_name}=", Base64.strict_encode64(certificate.to_der))
    validate_certificate_issuer(certificate, field_name)
    rescue
      errors[field_name] << "is malformed"
  end

  def convert_value_to_x509_certificate(cert_value)
    begin
      OpenSSL::X509::Certificate.new(cert_value)
    rescue
      OpenSSL::X509::Certificate.new(Base64.decode64(cert_value))
    end
  end

  def validate_certificate_issuer(certificate, field_name)
    if is_integration?
      unless certificate.issuer.to_s.include?("CN=#{OnboardingForm::CERTIFICATE_ISSUER_INTEGRATION}")
        errors.add(field_name, "Certificates for the integration environment must be issued by #{OnboardingForm::CERTIFICATE_ISSUER_INTEGRATION}")
      end
    else
      unless certificate.issuer.to_s.include?("CN=#{OnboardingForm::CERTIFICATE_ISSUER_PRODUCTION}")
        errors.add(field_name, "Certificates for the production environment must be issued by #{OnboardingForm::CERTIFICATE_ISSUER_PRODUCTION}")
      end
    end
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
