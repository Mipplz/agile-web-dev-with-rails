class PaymentResultController < ApplicationController
  before_action :set_order

  def success
    @order[:payment_status] = :accepted
    @order.save
    redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks')
    session[:order] = nil
    session[:order_amount] = nil
  end

  def failure
    @order[:payment_status] = :rejected
    @order.save
    redirect_to payment_url(locale: I18n.locale), notice: 'Failure + reason'
  end

  private

  def set_order
    @order = Order.find(session[:order]['id'])
  end
end
