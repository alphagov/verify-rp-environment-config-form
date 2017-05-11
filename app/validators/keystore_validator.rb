class KeystoreValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    der_keystore = value.read
    value.rewind
    lines = Base64.strict_encode64(der_keystore).scan(/.{1,64}/)
    lines.unshift "-----BEGIN #{'PRIVATE KEY'}-----"
    lines.push "-----END #{'PRIVATE KEY'}-----"
    pem_string = lines.join("\n")
    OpenSSL::PKey::RSA.new(pem_string)
  rescue
    record.errors[attribute] << 'is not a DER-encoded PKCS8 keystore'
  end
end