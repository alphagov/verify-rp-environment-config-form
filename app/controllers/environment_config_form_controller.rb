class EnvironmentConfigFormController < ApplicationController

  def start
    @onboarding_form = OnboardingForm.new({})
    render 'environment_config_form', :layout => 'application'
  end

  def submit
    @onboarding_form = OnboardingForm.new(params['onboarding_form'])
    render 'environment_config_form', :layout => 'application'
  end
end
