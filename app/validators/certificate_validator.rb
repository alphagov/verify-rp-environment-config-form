class CertificateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    cert = value.read
    value.rewind
    OpenSSL::X509::Certificate.new(cert)
  rescue
    record.errors[attribute] << 'is not an X509 certificate in PEM format'
  end
end