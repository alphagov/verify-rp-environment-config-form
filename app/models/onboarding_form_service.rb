class OnboardingFormService

  attr_reader :zendesk_client

  USER_ACCOUNT_CREATION_ATTRIBUTES = {
      user_account_first_name: 'FIRST_NAME',
      user_account_middle_name: 'MIDDLE_NAME',
      user_account_surname: 'SURNAME',
      user_account_dob: 'DATE_OF_BIRTH',
      user_account_current_address: 'CURRENT_ADDRESS',
      user_account_address_history: 'ADDRESS_HISTORY',
      user_account_cycle_3: 'CYCLE_3'
  }

  def initialize(zendesk_client)
    @zendesk_client = zendesk_client
  end

  def save(onboarding_form)
    @zendesk_client.create_ticket(
      ticket: {
        requester: {
          name: value_or_default(onboarding_form.contact_details_name),
          email: value_or_default(onboarding_form.contact_details_email)
        },
        :subject => "#{value_or_default(onboarding_form.service_display_name)}: #{value_or_default(onboarding_form.environment_access)} [requestor: #{value_or_default(onboarding_form.contact_details_name)}]",
        :comment => {
            :body => <<~EOF
              Environment access:
              #{ value_or_default(onboarding_form.environment_access) }

              Service entity id:
              #{ value_or_default(onboarding_form.service_entity_id) }

              Matching service entity id:
              #{ value_or_default(onboarding_form.matching_service_entity_id) }

              Matching service url:
              #{ value_or_default(onboarding_form.matching_service_url) }

              Service start page URL:
              #{ value_or_default(onboarding_form.service_homepage_url) }

              Assertion consumer services https url:
              #{ value_or_default(onboarding_form.assertion_consumer_services_https_url) }

              Requested cycle 3 attribute name (if applicable):
              #{ value_or_default(onboarding_form.cycle3_attribute_name) }

              Matching service user account creation URL:
              #{ value_or_default(onboarding_form.user_account_creation_uri) }

              Transaction signature verification certificate:
              #{ value_or_default(onboarding_form.signature_verification_certificate_transaction) }

              Transaction encryption certificate:
              #{ value_or_default(onboarding_form.encryption_certificate_transaction) }

              Matching Service signature verification certificate:
              #{ value_or_default(onboarding_form.signature_verification_certificate_match) }

              Matching Service encryption certificate:
              #{ value_or_default(onboarding_form.encryption_certificate_match) }

              Requested attributes for creating user account:
              #{ value_or_default(user_account_attributes(onboarding_form).join(', '))}

              Service display name:
              #{ value_or_default(onboarding_form.service_display_name) }

              Other ways display name:
              #{ value_or_default(onboarding_form.other_ways_display_name) }

              Other ways complete transaction:
              #{ value_or_default(onboarding_form.other_ways_complete_transaction) }

              Name:
              #{ value_or_default(onboarding_form.contact_details_name) }

              Email:
              #{ value_or_default(onboarding_form.contact_details_email) }

              Phone:
              #{ value_or_default(onboarding_form.contact_details_phone) }

              Message:
              #{ value_or_default(onboarding_form.contact_details_message) }

              Service:
              #{ value_or_default(onboarding_form.contact_details_service) }

              Department:
              #{ value_or_default(onboarding_form.contact_details_department) }

              Username for stub idp:
              #{ value_or_default(onboarding_form.stub_idp_username) }

              Hashed password for stub idp:
              #{ value_or_default(onboarding_form.hashed_password) }

              Follow this guide on how to onboard an RP: https://github.digital.cabinet-office.gov.uk/gds/ida-hub/wiki/Onboarding-an-rp
            EOF
        }
      }
    )
  end

  private

  def user_account_attributes(onboarding_form)
    {
      user_account_first_name: ['FIRST_NAME', 'FIRST_NAME_VERIFIED'],
      user_account_middle_name: ['MIDDLE_NAME', 'MIDDLE_NAME_VERIFIED'],
      user_account_surname: ['SURNAME', 'SURNAME_VERIFIED'],
      user_account_dob: ['DATE_OF_BIRTH', 'DATE_OF_BIRTH_VERIFIED'],
      user_account_current_address: ['CURRENT_ADDRESS', 'CURRENT_ADDRESS_VERIFIED'],
      user_account_address_history: ['ADDRESS_HISTORY', 'ADDRESS_HISTORY_VERIFIED'],
      user_account_cycle_3: ['CYCLE_3']
    }.collect { |attribute_name, attr|
      onboarding_form.send(attribute_name) != '0' ? attr : []
    }.flatten
  end

  def value_or_default(value, default = '-')
    if value.nil? || value.empty?
      default
    else
      value
    end
  end

end
