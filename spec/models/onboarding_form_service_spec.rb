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
        signature_verification_certificate_transaction: GOOD_CERT,
        signature_verification_certificate_match: GOOD_CERT,
        encryption_certificate_transaction: GOOD_CERT,
        encryption_certificate_match: GOOD_CERT,
        user_account_creation_uri: 'https://example.com',
        user_account_first_name: true,
        user_account_middle_name: true,
        user_account_surname: true,
        user_account_dob: true,
        user_account_current_address: true,
        user_account_cycle_3: true,
        contact_details_phone: '012345 678 912',
        contact_details_message: 'Some text',
        service_display_name: 'Example service',
        other_ways_display_name: 'Example service',
        other_ways_complete_transaction: 'Some text',
        contact_details_name: 'username',
        contact_details_email: 'example@example.com',
        contact_details_service: 'Example service',
        contact_details_department: 'Example department'
      })

      tickets = instance_double('ZendeskAPI::Collection')
      zendesk_client = double('ZendeskAPI::Client', :tickets => tickets)
      created_ticket = instance_double('ZendeskAPI::Ticket')

      expect(tickets).to receive(:create).with({
        subject: 'Example service: Integration access request [requestor: username]',
        comment: {
          value: <<~EOF
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
              #{GOOD_CERT}
              
              Transaction encryption certificate:
              #{GOOD_CERT}
              
              Matching Service signature verification certificate:
              #{GOOD_CERT}
              
              Matching Service encryption certificate:
              #{GOOD_CERT}
              
              Requested attributes for creating user account:
              FIRST_NAME, FIRST_NAME_VERIFIED, MIDDLE_NAME, MIDDLE_NAME_VERIFIED, SURNAME, SURNAME_VERIFIED, DATE_OF_BIRTH, DATE_OF_BIRTH_VERIFIED, CURRENT_ADDRESS, CURRENT_ADDRESS_VERIFIED, CYCLE_3

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
              
              Hashed password for stub idp:
              TODO
                          
              Follow this guide on how to onboard an RP: https://github.digital.cabinet-office.gov.uk/gds/ida-hub/wiki/Onboarding-an-rp
          EOF
        }
      }).and_return created_ticket

      expect(OnboardingFormService.new(zendesk_client).save(form)).to eq(created_ticket)
    end

  end

end