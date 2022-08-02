require 'securerandom'
require 'digest/md5'

class PaymentsController < ApplicationController
  before_action :set_order

  def index
    @session_id = SecureRandom.uuid
    @ts = Time.now.to_i
    @amount = format("%0.02f", session[:order_amount])
    @checksum = Digest::MD5.hexdigest("#{::APP_ID}|sale|#{@session_id}|#{@amount}|PLN|#{@ts}|#{::CHECKSUM_KEY}")
    @error_msg = ::ISSUER_RESPONSE_CODES['issuer_response_codes'][@order['issuer_response_code']] if @order['reject_reason']
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end
end
