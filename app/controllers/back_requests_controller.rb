class BackRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authorize
  http_basic_authenticate_with name: ::BACK_REQUEST_SETTINGS['login'], password: ::BACK_REQUEST_SETTINGS['password']

  def update
    return if params['subject'] != 'payment'

    order_id = params["description"].split(':').last.to_i
    order = Order.find(order_id)
    head :ok if order.update(order_params)
  end

  private

  def order_params
    params.permit(:payment_status, :issuer_response_code, :reject_reason)
  end
end
