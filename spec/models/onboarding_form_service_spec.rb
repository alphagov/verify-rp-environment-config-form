require 'rails_helper'
require 'zendesk_api'

describe OnboardingFormService do

  def create_valid_form
    OnboardingForm.new({
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
        stub_idp_password: 'stup-idp-password',
        level_of_assurance: 'LEVEL_1'
    })
  end

  context 'prepare the zendesk ticket' do

    it 'should generate a valid zendesk ticket' do
      json = {"results": [{ "name": "Connecting to Verify", "created_at":  "2009-05-13T00:07:08Z", "updated_at": "2011-07-22T00:11:12Z", "id": 360000257114, "result_type": "group", "url": "http://example.com" }], "count": 1}.to_json
      stub_request(:get, "https://example.com/api/v2/search?query=type:group%20name:'Connecting%20to%20Verify'")
          .with(:headers => {'Accept'=>'application/json'})
          .to_return(:status => 200, :body => json, :headers => { :content_type => "application/json", :content_length => json.size })

      form = create_valid_form

      expect(OnboardingFormService.generate_ticket_body(form)).to eq({
          requester: {
              name: 'username',
              email: 'example@example.com'
          },
          group_id: 360000257114,
          subject: 'Example service: Integration access request [requestor: username]',
          comment: {
              body: <<~EOF
                Environment access:
                Integration access request

                Level of assurance:
                LEVEL_1

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

                Follow this guide on how to onboard an RP: https://github.com/alphagov/ida-hub/wiki/Onboarding-an-rp
          EOF
          }
      })
    end

    it 'should generate an empty zendesk ticket' do
      json = {"results": [{ "name": "Connecting to Verify", "created_at":  "2009-05-13T00:07:08Z", "updated_at": "2011-07-22T00:11:12Z", "id": 360000257114, "result_type": "group", "url": "http://example.com" }], "count": 1}.to_json
      stub_request(:get, "https://example.com/api/v2/search?query=type:group%20name:'Connecting%20to%20Verify'")
          .with(:headers => {'Accept'=>'application/json'})
          .to_return(:status => 200, :body => json, :headers => { :content_type => "application/json", :content_length => json.size })

      form = OnboardingForm.new({
          environment_access: '',
          level_of_assurance: '',
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
          stub_idp_password: '',
      })

      expect(OnboardingFormService.generate_ticket_body(form)).to eq({
          requester: {
              name: '-',
              email: '-'
          },
          group_id: 360000257114,
          subject: '-: - [requestor: -]',
          comment: {
              body: <<~EOF
                Environment access:
                -

                Level of assurance:
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

                Follow this guide on how to onboard an RP: https://github.com/alphagov/ida-hub/wiki/Onboarding-an-rp
          EOF
          }
      })
    end

  end

  context 'manage config files' do

    it 'should delete newly created config files' do

      testFiles = ['./tmp/newTestFile1', './tmp/newTestFile2']

      testFiles.each { |file| File.new(file, 'w') }

      testFiles.each do |file|
        expect(File.exist?(file)).to eq(true)
      end

      OnboardingFormService.delete_config_files(testFiles)

      testFiles.each do |file|
        expect(File.exist?(file)).to eq(false)
      end
    end

    it 'should generate config files for a valid form' do
      form = create_valid_form

      expected_config_files = [
          './tmp/example-department-example-service.yml',
          './tmp/example-department-example-service-msa.yml',
          './tmp/post-office-example-department-example-service.yml',
          './tmp/experian-example-department-example-service.yml'
      ]

      generated_config_files = OnboardingFormService.generate_config_files(form)

      expect(generated_config_files).to eq(expected_config_files)

      OnboardingFormService.delete_config_files(generated_config_files)
    end

    it 'should add the config files as an internal note to the Zendesk ticket' do
      form = create_valid_form
      generated_config_files = OnboardingFormService.generate_config_files(form)

      ticket = double(ZendeskAPI::Ticket)
      allow(ticket).to receive(:comments).and_return([])
      allow(ticket).to receive(:update).with(hash_including(:comment)) do |comment|
        ticket.comments << comment
      end
      allow(ticket).to receive(:save!)

      stub_request(:post, "https://example.com/api/v2/uploads")
          .to_return(:status => 200, :body => "", :headers => {})

      OnboardingFormService.upload_config_files(ticket, generated_config_files)

      expect(ticket.comments.count).to eq(1)
      uploads = ticket.comments[0][:comment].uploads.map {| upload | upload.file }
      expect(uploads.count).to eq(4)
      expect(uploads).to match_array(generated_config_files)

      OnboardingFormService.delete_config_files(generated_config_files)
    end
  end

end
