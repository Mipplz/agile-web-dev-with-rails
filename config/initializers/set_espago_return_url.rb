::SERVER_PORT = Rails.env.test? ? '1234' : '3000'
::ESPAGO_RETURN_URL = "http://127.0.0.1:#{::SERVER_PORT}".freeze
::ESPAGO_RETURN_POSITIVE_URL = "#{::ESPAGO_RETURN_URL}/payment_result/success".freeze
::ESPAGO_RETURN_NEGATIVE_URL = "#{::ESPAGO_RETURN_URL}/payment_result/failure".freeze
