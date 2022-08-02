class AdminController < ApplicationController
  before_action :authorize
  def index
    @total_orders = Order.count
  end
end
