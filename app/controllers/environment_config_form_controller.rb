class EnvironmentConfigFormController < ApplicationController

  def start
    @onboarding_form = OnboardingForm.new({'environment_access' => 'integration-access-request'})
    render 'environment_config_form'
  end

  def submit
    @onboarding_form = OnboardingForm.new(params['onboarding_form'].permit(OnboardingForm::ALL_FIELDS))

    if !@onboarding_form.valid?
      return render 'environment_config_form'
    end

    @ticket = OnboardingFormService.new(ZendeskClientFactory.create).save @onboarding_form
    if !@ticket.errors.nil? && @ticket.errors.any?
      @onboarding_form.errors[:base] << 'Something happened with zendesk'
      return render 'environment_config_form'
    end

    render 'confirmation'
  end

end
