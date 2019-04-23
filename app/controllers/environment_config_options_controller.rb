class EnvironmentConfigOptionsController < ApplicationController

  def start
    @onboarding_options = OnboardingOptions.new({
                            'part' => "environment",
                            'environment_access' => 'integration-access-request',
                            'level_of_assurance' => 'LEVEL_1',
                            'service_provider' => 'VSP',
                            'reuse_service_config' => 'No',
                            'matching_service_adapter' => 'None',
                            'reuse_msa_config' => 'Yes'
                            })

    session[:options] = @onboarding_options.session_params
    go_next
  end

  def option_environment
    session[:options].merge!(get_onboarding_options_params, {'part' => 'service'})
    @onboarding_options = OnboardingOptions.new(session[:options])
    go_next
  end

  def option_service
    session[:options].merge!(get_onboarding_options_params)
    next_part = session[:options]['service_provider'] == 'VSP' ? 'msa_use' : 'msa_reuse'
    session[:options].merge!('part' => next_part)
    @onboarding_options = OnboardingOptions.new(session[:options])
    go_next
  end

  def option_msa_use
    session[:options].merge!(get_onboarding_options_params)
    next_part = session[:options]['matching_service_adapter'] == 'MSA' ? 'msa_reuse' : 'done'
    session[:options].merge!('part' => next_part)
    @onboarding_options = OnboardingOptions.new(session[:options])
    go_next
  end

  def option_msa_reuse
    session[:options].merge!(get_onboarding_options_params, {'part' => 'done'})
    @onboarding_options = OnboardingOptions.new(session[:options])
    go_next
  end

  private

  def go_next
    if @onboarding_options.part == 'done'
      redirect_to '/config'
    else
      render 'environment_config_options'
    end
  end

  def get_onboarding_options_params
    params['onboarding_options'].permit(OnboardingOptions::ALL_FIELDS)
  end
end
