class ContactValidator < ActiveModel::Validator

  REQUIRED_FIELDS = [
      :contact_details_name,
      :contact_details_service,
      :contact_details_department
  ]

  def validate(record)
    REQUIRED_FIELDS.each {|field_name| record.validate_not_empty(field_name)}
    record.validate_email(:contact_details_email)
  end

end