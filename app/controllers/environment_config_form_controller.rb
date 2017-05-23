class EnvironmentConfigFormController < ApplicationController

  def start
    @onboarding_form = OnboardingForm.new({})
    render 'environment_config_form', :layout => 'application'
  end

  def submit
    @onboarding_form = OnboardingForm.new(params['onboarding_form'])
    if @onboarding_form.valid?
      redirect_to '/confirmation'
    else
      render 'environment_config_form', :layout => 'application'
    end
  end
end
