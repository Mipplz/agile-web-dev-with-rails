require 'securerandom'
require 'digest/md5'

class PaymentController < ApplicationController
  skip_before_action :authorize
  before_action :set_order, only: :back_request

  def index
    @order = session[:order]
    @app_id = 'ms_89fImw6knEx'
    @checksum_key = 'C2HatpHQLcMz'
    @session_id = SecureRandom.uuid
    @ts = Time.now.to_i
    @amount = format("%0.02f", session[:order_amount])
    @checksum = Digest::MD5.hexdigest("#{@app_id}|sale|#{@session_id}|#{@amount}|PLN|#{@ts}|#{@checksum_key}")
  end

  def back_request
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:name, :address, :email, :pay_type, :payment_status)
  end
end
