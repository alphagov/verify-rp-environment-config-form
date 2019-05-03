Rails.application.routes.draw do
  get '/' => 'environment_config_options#start'
  post '/option_environment' => 'environment_config_options#option_environment'
  post '/option_service' => 'environment_config_options#option_service'
  post '/option_use' => 'environment_config_options#option_msa_use'
  post '/option_reuse' => 'environment_config_options#option_msa_reuse'
  get '/config' => 'environment_config_form#start'
  post '/submit' => 'environment_config_form#submit'
end
