# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
  Rails.application.config.filter_parameters += [
                                                 :password,
                                                 :contact_details_name,
                                                 :contact_details_email,
                                                 :contact_details_phone
                                                ]
