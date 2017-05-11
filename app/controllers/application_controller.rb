class ApplicationController < ActionController::Base
  # http_basic_authenticate_with name: ENV.fetch('USERNAME'), password: ENV.fetch('PASSWORD')
  protect_from_forgery with: :exception
end
