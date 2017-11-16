class EnvironmentConfigFormController < ApplicationController

  def start
    @onboarding_form = OnboardingForm.new({'environment_access' => 'integration-access-request'})
    render 'environment_config_form'
  end

  def submit
    @onboarding_form = OnboardingForm.new(get_onboarding_form_params)

    if !@onboarding_form.valid?
      return render 'environment_config_form'
    end

    begin
      ticket_body = OnboardingFormService.generate_ticket_body(@onboarding_form)
      @ticket = OnboardingFormService.save(ticket_body)

      raise 'problem creating ticket' if @ticket.nil?

      begin
        config_files = OnboardingFormService.generate_config_files(@onboarding_form)
        OnboardingFormService.upload_config_files(@ticket, config_files)
        OnboardingFormService.delete_config_files(config_files)

      rescue RuntimeError => err
        Rails.logger.error(err)
      end

      render 'confirmation'

    rescue RuntimeError => err
      Rails.logger.error(err)
      @error = 'Something happened with zendesk'
      return render 'environment_config_form'
    end
  end

  private

  def get_onboarding_form_params
    user_input = params['onboarding_form'].permit(OnboardingForm::ALL_FIELDS)

    OnboardingForm::CERTIFICATE_FIELDS.each {|field_name|
      cert = params["#{field_name}-attachment"]
      user_input[field_name] = cert.read if cert
    }

    user_input
  end
end
