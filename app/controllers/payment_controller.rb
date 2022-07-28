# CR: [Michał] W railsach prawie nigdy nie robimy require
require 'securerandom'
require 'digest/md5'

class PaymentController < ApplicationController
  skip_before_action :authorize
  before_action :set_order

  def index
    # CR: [matik] `@app_id` i `@checksum_key` na pewno powinny być w zmiennych środowiskowych lub w pliku konfiguracyjnym i nie jawnie!
    # CR: [Michał] Najlepiej wyrzucać jakąkolwiek logikę poza kontroler, jakiś moduł, albo klasa, która buduje parametry
    @app_id = 'ms_89fImw6knEx'
    # CR: [Michał] Credentiale przechowujemy niejawnie, nigdy nie w kodzie! Nie wolno trzymać credentiali w repo
    # CR: [garbus] - zrób sobie kiedys na githubie search commit by name - "removing credentials from code" ;)
    #  nie polecam.
    @checksum_key = 'C2HatpHQLcMz'
    @session_id = SecureRandom.uuid
    @ts = Time.now.to_i
    @amount = format("%0.02f", session[:order_amount])
    @checksum = Digest::MD5.hexdigest("#{@app_id}|sale|#{@session_id}|#{@amount}|PLN|#{@ts}|#{@checksum_key}")
    # CR: [garbus] - za długa linia! - spróbuj się zmieścic w 80 lub 120 znakach MAX.
    # CR: [matik] nie czaję dlaczego robisz `@order['reject_reason']` zamiast `@order.reject_reason` lub `@order&.reject_reason`
    @error_msg = ::ISSUER_RESPONSE_CODES['issuer_response_codes', @order['issuer_response_code']] if @order['reject_reason']
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end
end
