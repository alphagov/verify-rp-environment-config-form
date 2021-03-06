require 'yaml'

class ConfigFileService

  def initialize(onboarding_form)
    @form = onboarding_form
    @simple_id = "#{@form.contact_details_department}-#{@form.contact_details_service}".gsub(' ','-').downcase
    @level_of_assurance = "#{@form.options.level_of_assurance}"
  end

  def generate_transaction_config_file


    transaction_yaml = YAML.load_file('./app/models/rp-transaction-template.yml')
    transaction_yaml['entityId'] = @form.service_entity_id
    if @level_of_assurance == 'LEVEL_1'
      transaction_yaml['levelsOfAssurance'][0] = 'LEVEL_1'
      transaction_yaml['levelsOfAssurance'][1] = 'LEVEL_2'
    else
      transaction_yaml['levelsOfAssurance'][0] = 'LEVEL_2'
    end
    transaction_yaml['assertionConsumerServices'][0]['uri'] = @form.assertion_consumer_services_https_url
    transaction_yaml['signatureVerificationCertificates'][0]['x509'] = @form.signature_verification_certificate_transaction
    transaction_yaml['encryptionCertificate']['x509'] = @form.encryption_certificate_transaction
    transaction_yaml['matchingServiceEntityId'] = @form.matching_service_entity_id
    transaction_yaml['matchingProcess']['cycle3AttributeName'] = @form.cycle3_attribute_name
    transaction_yaml['serviceHomepage'] = @form.service_homepage_url
    transaction_yaml['userAccountCreationAttributes'] = @form.get_user_account_attributes_array
    transaction_yaml['simpleId'] = @simple_id

    transaction_config_filename = "./tmp/#{@simple_id}.yml"

    File.open(transaction_config_filename, "w") { |f| f.write(YAML.dump(transaction_yaml)) }

    transaction_config_filename

  end

  def generate_msa_config_file

    msa_yml = YAML.load_file('./app/models/rp-msa-template.yml')

    msa_yml['entityId'] = @form.matching_service_entity_id
    msa_yml['signatureVerificationCertificates'][0]['x509'] = @form.signature_verification_certificate_match
    msa_yml['encryptionCertificate']['x509'] = @form.encryption_certificate_match
    msa_yml['uri'] = @form.matching_service_url
    msa_yml['userAccountCreationUri'] = @form.user_account_creation_uri

    msa_config_filename = "./tmp/#{@simple_id}-msa.yml".gsub(' ','-').downcase

    File.open(msa_config_filename, "w") { |f| f.write(YAML.dump(msa_yml)) }

    msa_config_filename
  end

  def generate_stub_idp_file(idp)
    stub_idp_yml = YAML.load_file('./app/models/stub-idp-template.yml')


    stub_idp_yml['entityId'] = "http://stub_idp.acme.org/#{idp}-#{@simple_id}/SSO/POST"
    stub_idp_yml['simpleId'] = idp
    stub_idp_yml['onboardingTransactionEntityIds'][0] = @form.service_entity_id
    stub_idp_yml['supportedLevelsOfAssurance'] = ["LEVEL_1"] if @level_of_assurance == "LEVEL_1"
    stub_idp_yml['onboardingLevelsOfAssurance'] = ["LEVEL_1"] if @level_of_assurance == "LEVEL_1"

    stub_idp_filename = "./tmp/#{idp}-#{@simple_id}.yml"

    File.open(stub_idp_filename, "w") { |f| f.write(YAML.dump(stub_idp_yml)) }

    stub_idp_filename
  end

end
