require 'zendesk_api'

class OnboardingFormService
  class << self

    def save(ticket_body)
      ZendeskAPI::Ticket.create(ZENDESK_CLIENT, ticket_body)
    end

    def upload_config_files(ticket, config_files)
      # if the ticket's body isn't overwritten, the entire form is re-posted
      comment = ZendeskAPI::Ticket::Comment.new(ZENDESK_CLIENT, {
          body: 'Automatically generated config files:',
          public: false
      })

      config_files.each do |file|
        comment.uploads << file
      end

      comment.save!
      ticket.update(comment: comment)
      ticket.save!
    end

    def generate_config_files(onboarding_form)
      config_file_service = ConfigFileService.new(onboarding_form)
      [
          config_file_service.generate_transaction_config_file,
          config_file_service.generate_msa_config_file,
          config_file_service.generate_stub_idp_file('post-office'),
          config_file_service.generate_stub_idp_file('experian'),
      ]
    end

    def generate_ticket_body(onboarding_form)
      {
          requester: {
              name: value_or_default(onboarding_form.contact_details_name),
              email: value_or_default(onboarding_form.contact_details_email)
          },
          group_id: ZENDESK_NEW_TICKET_GROUP_ID,
          subject: "[GOV.UK Verify] #{value_or_default(onboarding_form.service_display_name)}: #{value_or_default(onboarding_form.environment_access)} [requestor: #{value_or_default(onboarding_form.contact_details_name)}]",
          comment: {
              body: <<~EOF
                Environment access:
                #{ value_or_default(onboarding_form.environment_access) }

                Level of assurance:
                #{ value_or_default(onboarding_form.level_of_assurance) }

                Service entity id:
                #{ value_or_default(onboarding_form.service_entity_id) }

                Matching service entity id:
                #{ value_or_default(onboarding_form.matching_service_entity_id) }

                Service start page URL:
                #{ value_or_default(onboarding_form.service_homepage_url) }

                Assertion consumer services https url:
                #{ value_or_default(onboarding_form.assertion_consumer_services_https_url) }

                Matching service url:
                #{ value_or_default(onboarding_form.matching_service_url) }

                Matching service user account creation URL:
                #{ value_or_default(onboarding_form.user_account_creation_uri) }

                Service display name:
                #{ value_or_default(onboarding_form.service_display_name) }

                Other ways display name:
                #{ value_or_default(onboarding_form.other_ways_display_name) }

                Other ways complete transaction:
                #{ value_or_default(onboarding_form.other_ways_complete_transaction) }

                Transaction signature verification certificate:
                #{ value_or_default(onboarding_form.signature_verification_certificate_transaction) }

                Matching Service signature verification certificate:
                #{ value_or_default(onboarding_form.signature_verification_certificate_match) }

                Transaction encryption certificate:
                #{ value_or_default(onboarding_form.encryption_certificate_transaction) }

                Matching Service encryption certificate:
                #{ value_or_default(onboarding_form.encryption_certificate_match) }

                Requested attributes for creating user account:
                #{ value_or_default(onboarding_form.get_user_account_attributes_array.join(', '))}

                Requested cycle 3 attribute name (if applicable):
                #{ value_or_default(onboarding_form.cycle3_attribute_name) }

                Username for stub idp:
                #{ value_or_default(onboarding_form.stub_idp_username) }

                Hashed password for stub idp:
                #{ value_or_default(onboarding_form.hashed_password) }

                Name:
                #{ value_or_default(onboarding_form.contact_details_name) }

                Email:
                #{ value_or_default(onboarding_form.contact_details_email) }

                Phone:
                #{ value_or_default(onboarding_form.contact_details_phone) }

                Service:
                #{ value_or_default(onboarding_form.contact_details_service) }

                Department:
                #{ value_or_default(onboarding_form.contact_details_department) }

                Message:
                #{ value_or_default(onboarding_form.contact_details_message) }

                Follow this guide on how to onboard an RP: https://github.com/alphagov/ida-hub/wiki/Onboarding-an-rp
          EOF
          }
      }
    end

    def delete_config_files(files)
      files.each do |f|
        File.delete(f)
      end
    end

    private

    def value_or_default(value, default = '-')
      if value.nil? || value.empty?
        default
      else
        value
      end
    end
  end
end
