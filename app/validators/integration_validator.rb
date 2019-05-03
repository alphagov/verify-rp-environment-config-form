class IntegrationValidator < ActiveModel::Validator

  def validate(record)
    record.validate_not_empty(:stub_idp_username)
    record.validate_strong_password(:stub_idp_password)
  end

end