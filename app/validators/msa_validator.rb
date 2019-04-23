class MSAValidator < ActiveModel::Validator

  REQUIRED_URL_FIELDS = [
      :matching_service_entity_id
  ]

  NEW_REQUIRED_URL_FIELDS = [
      :matching_service_url,
      :user_account_creation_uri
  ]

  CERTIFICATE_FIELDS = [
      :signature_verification_certificate_match,
      :encryption_certificate_match
  ]

  def validate(record)

    REQUIRED_URL_FIELDS.each {|field_name| record.validate_url(field_name)}

    unless record.is_reuse_msa_config?
      NEW_REQUIRED_URL_FIELDS.each {|field_name| record.validate_url(field_name)}
      CERTIFICATE_FIELDS.each {|field_name| record.validate_certificate(field_name)}
    end

  end

end