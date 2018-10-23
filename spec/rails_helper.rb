ENV['RAILS_ENV'] ||= 'test'
ENV['ZENDESK_BASE_URL'] = 'https://example.com/api/v2/'
ENV['ZENDESK_TOKEN'] = 'some-token'
ENV['ZENDESK_USERNAME'] = 'idasupport@example.com'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.filter_run_excluding :smoke => true
  if config.filter_manager.inclusions[:smoke]
    Capybara.javascript_driver = :selenium_remote_firefox
    Capybara.register_driver "selenium_remote_firefox".to_sym do |app|
      Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://selenium-hub:4444/wd/hub", desired_capabilities: :firefox)
    end
  end
end
