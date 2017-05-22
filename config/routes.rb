Rails.application.routes.draw do
  get '/' => 'environment_config_form#start'
end
