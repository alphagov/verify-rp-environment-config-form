class OnboardingFormService

  attr_reader :zendesk_client

  USER_ACCOUNT_CREATION_ATTRIBUTES = {
      user_account_first_name: 'FIRST_NAME',
      user_account_middle_name: 'MIDDLE_NAME',
      user_account_surname: 'SURNAME',
      user_account_dob: 'DATE_OF_BIRTH',
      user_account_current_address: 'CURRENT_ADDRESS',
      user_account_cycle_3: 'CYCLE_3'
  }

  def initialize(zendesk_client)
    @zendesk_client = zendesk_client
  end

  def save(onboarding_form)
    @zendesk_client.tickets.create(
        :subject => "#{onboarding_form.service_display_name}: #{onboarding_form.environment_access} [requestor: #{onboarding_form.contact_details_name}]",
        :comment => {
            :value => <<~EOF
              Environment access: 
              #{ onboarding_form.environment_access || '-' }
              
              Service entity id: 
              #{ onboarding_form.service_entity_id || '-' }
              
              Matching service entity id: 
              #{ onboarding_form.matching_service_entity_id || '-' }
              
              Matching service url: 
              #{ onboarding_form.matching_service_url || '-' }

              Service start page URL:
              #{ onboarding_form.service_homepage_url || '-' }
              
              Assertion consumer services https url: 
              #{ onboarding_form.assertion_consumer_services_https_url || '-' }

              Requested cycle 3 attribute name (if applicable):
              #{ onboarding_form.cycle3_attribute_name || '-' }

              Matching service user account creation URL:
              #{ onboarding_form.user_account_creation_uri || '-' }
              
              Transaction signature verification certificate:
              #{ onboarding_form.signature_verification_certificate_transaction || '-' }
              
              Transaction encryption certificate:
              #{ onboarding_form.encryption_certificate_transaction || '-' }
              
              Matching Service signature verification certificate:
              #{ onboarding_form.signature_verification_certificate_match || '-' }
              
              Matching Service encryption certificate:
              #{ onboarding_form.encryption_certificate_match || '-' }
              
              Requested attributes for creating user account:
              #{ user_account_attributes(onboarding_form).join(', ') || '-' }
              
              Service display name:
              #{ onboarding_form.service_display_name || '-' }
              
              Other ways display name:
              #{ onboarding_form.other_ways_display_name || '-' }
              
              Other ways complete transaction:
              #{ onboarding_form.other_ways_complete_transaction || '-' }
              
              Name:
              #{ onboarding_form.contact_details_name || '-' }
              
              Email:
              #{ onboarding_form.contact_details_email || '-' }
              
              Phone:
              #{ onboarding_form.contact_details_phone || '-' }
              
              Message:
              #{ onboarding_form.contact_details_message || '-' }
              
              Service:
              #{ onboarding_form.contact_details_service || '-' }
              
              Department:
              #{ onboarding_form.contact_details_department || '-' }
              
              Hashed password for stub idp:
              #{ onboarding_form.hashed_password || '-' }
                          
              Follow this guide on how to onboard an RP: https://github.digital.cabinet-office.gov.uk/gds/ida-hub/wiki/Onboarding-an-rp
            EOF
        }
    )
  end

  private

  def user_account_attributes(onboarding_form)
    {
      user_account_first_name: 'FIRST_NAME',
      user_account_middle_name: 'MIDDLE_NAME',
      user_account_surname: 'SURNAME',
      user_account_dob: 'DATE_OF_BIRTH',
      user_account_current_address: 'CURRENT_ADDRESS'
    }.collect { |attribute_name, attr|
      onboarding_form.send(attribute_name) ? [attr, "#{attr}_VERIFIED"] : nil
    }.compact.flatten + (onboarding_form.user_account_cycle_3 ? ['CYCLE_3'] : [])
  end
end