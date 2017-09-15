require 'rails_helper'

describe OnboardingFormService do

  context 'save the form' do

    it 'should construct a new zendesk ticket' do
      form = OnboardingForm.new({
        environment_access: 'Integration access request',
        service_entity_id: 'https://example.com',
        matching_service_entity_id: 'https://example.com/msa',
        matching_service_url: 'https://example.com/msa',
        service_homepage_url: 'https://example.com/start',
        assertion_consumer_services_https_url: 'https://example.com/process-response',
        cycle3_attribute_name: 'cycle3attr',
        signature_verification_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        signature_verification_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_transaction: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        encryption_certificate_match: GOOD_CERT_GOOD_ISSUER_INTEGRATION,
        user_account_creation_uri: 'https://example.com',
        user_account_first_name: true,
        user_account_middle_name: true,
        user_account_surname: true,
        user_account_dob: true,
        user_account_current_address: true,
        user_account_address_history: true,
        user_account_cycle_3: true,
        contact_details_phone: '012345 678 912',
        contact_details_message: 'Some text',
        service_display_name: 'Example service',
        other_ways_display_name: 'Example service',
        other_ways_complete_transaction: 'Some text',
        contact_details_name: 'username',
        contact_details_email: 'example@example.com',
        contact_details_service: 'Example service',
        contact_details_department: 'Example department',
        stub_idp_username: 'stub-idp-username',
        stub_idp_password: 'stup-idp-password'
      })

      zendesk_client = instance_double(ZendeskClient)

      expect(zendesk_client).to receive(:create_ticket).with({
        ticket: {
          requester: {
            name: 'username',
            email: 'example@example.com'
          },
          subject: 'Example service: Integration access request [requestor: username]',
          comment: {
            body: <<~EOF
                Environment access:
                Integration access request

                Service entity id:
                https://example.com

                Matching service entity id:
                https://example.com/msa

                Matching service url:
                https://example.com/msa

                Service start page URL:
                https://example.com/start

                Assertion consumer services https url:
                https://example.com/process-response

                Requested cycle 3 attribute name (if applicable):
                cycle3attr

                Matching service user account creation URL:
                https://example.com

                Transaction signature verification certificate:
                #{GOOD_CERT_GOOD_ISSUER_INTEGRATION}

                Transaction encryption certificate:
                #{GOOD_CERT_GOOD_ISSUER_INTEGRATION}

                Matching Service signature verification certificate:
                #{GOOD_CERT_GOOD_ISSUER_INTEGRATION}

                Matching Service encryption certificate:
                #{GOOD_CERT_GOOD_ISSUER_INTEGRATION}

                Requested attributes for creating user account:
                FIRST_NAME, FIRST_NAME_VERIFIED, MIDDLE_NAME, MIDDLE_NAME_VERIFIED, SURNAME, SURNAME_VERIFIED, DATE_OF_BIRTH, DATE_OF_BIRTH_VERIFIED, CURRENT_ADDRESS, CURRENT_ADDRESS_VERIFIED, ADDRESS_HISTORY, CYCLE_3

                Service display name:
                Example service

                Other ways display name:
                Example service

                Other ways complete transaction:
                Some text

                Name:
                username

                Email:
                example@example.com

                Phone:
                012345 678 912

                Message:
                Some text

                Service:
                Example service

                Department:
                Example department

                Username for stub idp:
                stub-idp-username

                Hashed password for stub idp:
                #{form.hashed_password}

                Follow this guide on how to onboard an RP: https://github.digital.cabinet-office.gov.uk/gds/ida-hub/wiki/Onboarding-an-rp
            EOF
          }
        }
      }).and_return :created_ticket

      expect(OnboardingFormService.new(zendesk_client).save(form)).to eq(:created_ticket)
    end

    it 'should construct a new zendesk ticket' do
      form = OnboardingForm.new({
        environment_access: '',
        service_entity_id: '',
        matching_service_entity_id: '',
        matching_service_url: '',
        service_homepage_url: '',
        assertion_consumer_services_https_url: '',
        cycle3_attribute_name: '',
        signature_verification_certificate_transaction: '',
        signature_verification_certificate_match: '',
        encryption_certificate_transaction: '',
        encryption_certificate_match: '',
        user_account_creation_uri: '',
        user_account_first_name: '0',
        user_account_middle_name: '0',
        user_account_surname: '0',
        user_account_dob: '0',
        user_account_current_address: '0',
        user_account_address_history: '0',
        user_account_cycle_3: '0',
        contact_details_phone: '',
        contact_details_message: '',
        service_display_name: '',
        other_ways_display_name: '',
        other_ways_complete_transaction: '',
        contact_details_name: '',
        contact_details_email: '',
        contact_details_service: '',
        contact_details_department: '',
        stub_idp_username: '',
        stub_idp_password: ''
      })

      zendesk_client = instance_double(ZendeskClient)

      expect(zendesk_client).to receive(:create_ticket).with({
        ticket: {
          requester: {
            name: '-',
            email: '-'
          },
          subject: '-: - [requestor: -]',
          comment: {
          body: <<~EOF
            Environment access:
            -

            Service entity id:
            -

            Matching service entity id:
            -

            Matching service url:
            -

            Service start page URL:
            -

            Assertion consumer services https url:
            -

            Requested cycle 3 attribute name (if applicable):
            -

            Matching service user account creation URL:
            -

            Transaction signature verification certificate:
            -

            Transaction encryption certificate:
            -

            Matching Service signature verification certificate:
            -

            Matching Service encryption certificate:
            -

            Requested attributes for creating user account:
            -

            Service display name:
            -

            Other ways display name:
            -

            Other ways complete transaction:
            -

            Name:
            -

            Email:
            -

            Phone:
            -

            Message:
            -

            Service:
            -

            Department:
            -

            Username for stub idp:
            -

            Hashed password for stub idp:
            #{form.hashed_password}

            Follow this guide on how to onboard an RP: https://github.digital.cabinet-office.gov.uk/gds/ida-hub/wiki/Onboarding-an-rp
          EOF
          }
        }
      }).and_return :created_ticket

      expect(OnboardingFormService.new(zendesk_client).save(form)).to eq(:created_ticket)
    end

  end

end
