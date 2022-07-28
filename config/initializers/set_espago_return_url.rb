# CR: [garbus] - to powinno byc w configach, a nie w initializersach!!! A co jak będziesz robil
# deploy na inne serwery niz localhost? Będziesz klienta redirectowal na jego wlasnego kompa w srodowisku
# produkcyjnym? ;)

::SERVER_PORT = Rails.env.test? ? '1234' : '3000'
::ESPAGO_RETURN_URL = "http://127.0.0.1:#{::SERVER_PORT}".freeze
::ESPAGO_RETURN_POSITIVE_URL = "#{::ESPAGO_RETURN_URL}/payment_result/success".freeze
::ESPAGO_RETURN_NEGATIVE_URL = "#{::ESPAGO_RETURN_URL}/payment_result/failure".freeze
# CR: [garbus] - brak newlinea!