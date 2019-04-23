
class OnboardingOptions
  include ActiveModel::Model
  include ActiveModel::Validations

  ALL_FIELDS = [
      :part,
      :environment_access,
      :level_of_assurance,
      :service_provider,
      :reuse_service_config,
      :matching_service_adapter,
      :reuse_msa_config
  ]

  ALL_FIELDS.each {|field_name| attr_accessor field_name }

  def initialize(attributes)
    super
  end

  def session_params
    {part: part,
     environment_access: environment_access,
     level_of_assurance: level_of_assurance,
     service_provider: service_provider,
     reuse_service_config:reuse_service_config,
     matching_service_adapter:matching_service_adapter,
     reuse_msa_config: reuse_msa_config}
  end

end
