RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  def bad_cert
    <<~EOF
      -----BEGIN CERTIFICATE-----
      BANANA
      -----END CERTIFICATE-----
    EOF
  end

  def good_cert
    <<~EOF
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
  end

  def oneline_cert
    'MIICvDCCAaQCCQDiHF/Fhzl3BTANBgkqhkiG9w0BAQsFADAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwHhcNMTcwMjAzMTcyOTUzWhcNMTcwMzA1MTcyOTUzWjAgMR4wHAYDVQQDFBV0ZXN0X21zYV9lbmNyeXB0aW9uXzEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCm9pfAowd8lzAvDzzeS2Y7XPtE8ofjbxB8/c9Dnpg3mVPaL/ZiOVaSSGZnGHIZdSIyikICdD+52pZ4WYLVwldSKHzLfdEOgZWE1FRd84SEDGWVCgTpeBCW7Gdo84Gf449zr/by9bzuFxBY8F6eC7qJQZq8q2Yf/gKiJbbDsqpBpdloLnkS/HEyYHgI4auJEEGQxdhPXJ5FQdipvgP/MbS0me9k+bfYBFvVIgxRb4Tkgskq+A/RUZXVkWfrH93LX+KbcRtudtjWrTM7bb1xR4jo5wbT5UTXDF/P8P844aERSyiLQWDkq8XT4TJCxq3C8uSixnkTkTXd7zWcIWvkDmoZAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAF64j02nUVj8sVz4zQSg6fQR3ySWF5RJvaecukm79LXr9yhILXqo0Q87nPC9QNQTmLDUxPD3qV2sHIifcBm3FG//Dv+dJPsgvrgEqwKRmIMewk92W9J7G4MeeOzHkU4DUT8l5vm/rbt60sVKp1J8K+W20X5qURqdDTHzzbAJt1CesyQS3DuN/JxhTp3g3xPNe//XmQ7hbzrL1UBX1b/z7Oqilhvx3ZRp6hRuY/QKdn9I8LgfN/rnWkfhOxkIjcqL3/fwdJGgHMcSpweWLsjabjstmZ0ZpxAHYM8kVuZY6aHGWAgWh/LCQgDC+3z6SMSyiip7qi1qWWmx7C1NScqLvPQ='
  end

  def bad_keystore
    'BANANA'
  end

  def good_keystore
    Base64.decode64(base64_pkcs8)
  end

  def base64_pkcs8
    'MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMzQQQrZk+4wYivu10LHnyRWia9H4PvkIsdm0ZkKef8I9vdOVw5fG/028qqQ/jDCXcauabwb8XxXHAhQEz9V8aJ++qJa0Tfl2JlAez98baXiXwAF/PdYxQV003wqwlWBvhTkUsBDWuU1uipyMZ3SrLRlq8ebedi5TH1yikAhvgU1AgMBAAECgYAmBuSMpykYKFOR5J6C/51EmeymZqoXGpx6eVShHZjZCUkRUbJIMNB5iyIzGQiY9P2ETg3Dp0yG0YWa5YMtVz+tnuXUwA6gx/nLQCoOlPmeKDKgVePx7d97JOHGgAjETmDsf9lY3Url7ERAxcXCfUPrNd4s8MXze4RU2w+4AVJ5AQJBAOt6q/h1nj63wJwRKWj+HEqdRkmSgdyQPOjzjV/SmR56UQzy8r9sLMEdcG+qN7/Z+AMBW4Wme1nuIS4O4GXwX50CQQDeqXVVqdjMcGOgGFBU53oR7v1iyOKDE8XuEIDZFwd43eBwE7YmGsAMC7SU0kqTRwc+9GtvIzj8kwihSwEfDeR5AkEAl7es72NQttYLikJgbN40ejqE28hCVUq1g93P+6ojr4hdijtJ/d2DpFUEaV3Bl6GncsBAKIdQOGv+Ar/hAqzx3QJAT7LUPt9WrIamAk3xoxJfzT+ADvXcrhJLzJS3qfzmPcsdZMCJeEYm66jc8E/9RY4s98nBErzGzxFKC4GvWxA78QJAKlyo9p0frZRPh2vhTnMpubTm0FedxpL4I8NCLWseEY5NnOcbyNuQ6RWFJLXn7j2ccAseKXXtYyEzwkPJ5y0KWA=='
  end
end
