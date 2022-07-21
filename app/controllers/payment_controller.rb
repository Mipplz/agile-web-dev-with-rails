require 'securerandom'
require 'digest/md5'

class PaymentController < ApplicationController
  skip_before_action :authorize
  before_action :set_order

  def index
    @app_id = 'ms_89fImw6knEx'
    @checksum_key = 'C2HatpHQLcMz'
    @session_id = SecureRandom.uuid
    @ts = Time.now.to_i
    @amount = format("%0.02f", session[:order_amount])
    @checksum = Digest::MD5.hexdigest("#{@app_id}|sale|#{@session_id}|#{@amount}|PLN|#{@ts}|#{@checksum_key}")
    @error_msg = ::ISSUER_RESPONSE_CODES['issuer_response_codes'][@order['issuer_response_code']] if @order['reject_reason']
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end
end
