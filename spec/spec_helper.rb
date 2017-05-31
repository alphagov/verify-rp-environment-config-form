require 'capybara/rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end

GOOD_CERT = <<~EOF
    -----BEGIN CERTIFICATE-----
    MIICvDCCAaQCCQDiHF/Fhzl3BTANBgkqhkiG9w0BAQsFADAgMR4wHAYDVQQDFBV0
    ZXN0X21zYV9lbmNyeXB0aW9uXzEwHhcNMTcwMjAzMTcyOTUzWhcNMTcwMzA1MTcy
    OTUzWjAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwggEiMA0GCSqG
    SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCm9pfAowd8lzAvDzzeS2Y7XPtE8ofjbxB8
    /c9Dnpg3mVPaL/ZiOVaSSGZnGHIZdSIyikICdD+52pZ4WYLVwldSKHzLfdEOgZWE
    1FRd84SEDGWVCgTpeBCW7Gdo84Gf449zr/by9bzuFxBY8F6eC7qJQZq8q2Yf/gKi
    JbbDsqpBpdloLnkS/HEyYHgI4auJEEGQxdhPXJ5FQdipvgP/MbS0me9k+bfYBFvV
    IgxRb4Tkgskq+A/RUZXVkWfrH93LX+KbcRtudtjWrTM7bb1xR4jo5wbT5UTXDF/P
    8P844aERSyiLQWDkq8XT4TJCxq3C8uSixnkTkTXd7zWcIWvkDmoZAgMBAAEwDQYJ
    KoZIhvcNAQELBQADggEBAF64j02nUVj8sVz4zQSg6fQR3ySWF5RJvaecukm79LXr
    9yhILXqo0Q87nPC9QNQTmLDUxPD3qV2sHIifcBm3FG//Dv+dJPsgvrgEqwKRmIMe
    wk92W9J7G4MeeOzHkU4DUT8l5vm/rbt60sVKp1J8K+W20X5qURqdDTHzzbAJt1Ce
    syQS3DuN/JxhTp3g3xPNe//XmQ7hbzrL1UBX1b/z7Oqilhvx3ZRp6hRuY/QKdn9I
    8LgfN/rnWkfhOxkIjcqL3/fwdJGgHMcSpweWLsjabjstmZ0ZpxAHYM8kVuZY6aHG
    WAgWh/LCQgDC+3z6SMSyiip7qi1qWWmx7C1NScqLvPQ=
    -----END CERTIFICATE-----
EOF
