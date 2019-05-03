class ServiceValidator < ActiveModel::Validator

  REQUIRED_URL_FIELDS = [
      :service_entity_id,
      :service_homepage_url,
      :assertion_consumer_services_https_url
  ]

  REUSE_REQUIRED_URL_FIELDS = [
      :reuse_service_entity_id
  ]

  NEW_SERVICE_REQUIRED_FIELDS = [
      :service_display_name,
      :other_ways_display_name,
      :other_ways_complete_transaction
  ]

  CERTIFICATE_FIELDS = [
      :signature_verification_certificate_transaction,
      :encryption_certificate_transaction
  ]

  def validate(record)

    REQUIRED_URL_FIELDS.each {|field_name| record.validate_url(field_name)}

    if record.is_reuse_service_config?
      REUSE_REQUIRED_URL_FIELDS.each {|field_name| record.validate_url(field_name)}
    else
      NEW_SERVICE_REQUIRED_FIELDS.each {|field_name| record.validate_not_empty(field_name)}
      CERTIFICATE_FIELDS.each {|field_name| record.validate_certificate(field_name)}
    end

  end

end