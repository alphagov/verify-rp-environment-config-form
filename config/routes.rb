Rails.application.routes.draw do
  get '/' => 'environment_config_form#start'
  post '/submit' => 'environment_config_form#submit'
end
