require 'rails_helper'
describe VerifyEnvironmentRpConfigForm::Application, 'configuration' do
  let(:config) { described_class.config }

  [:password, :contact_details_name, :contact_details_email, :contact_details_phone].each do |param|
    it "filters #{param.inspect} from logs" do
      expect(config.filter_parameters).to include(param)
    end
  end
end
