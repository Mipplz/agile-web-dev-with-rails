class PaymentResultController < ApplicationController
  skip_before_action :authorize
  before_action :set_order

  def success
    # CR: [matik] to się łatwo myli z Hashem, lepiej używać `@order.payment_status = :accepted`
    @order[:payment_status] = :accepted
    @order.save
    redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks')
    session[:order] = nil
    session[:order_amount] = nil
  end

  def failure
    @order[:payment_status] = :rejected
    @order.save
    redirect_to payment_url(locale: I18n.locale), notice: 'Payment failed'
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end
end
