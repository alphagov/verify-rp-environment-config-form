class EnvironmentConfigFormController < ApplicationController
  def start
    render 'environment_config_form', :layout => 'application'
  end
end
