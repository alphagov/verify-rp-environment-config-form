ENV['RAILS_ENV'] ||= 'test'
ENV['ZENDESK_BASE_URL'] = 'https://example.com/api/v2/'
ENV['ZENDESK_TOKEN'] = 'some-token'
ENV['ZENDESK_USERNAME'] = 'idasupport@example.com'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
