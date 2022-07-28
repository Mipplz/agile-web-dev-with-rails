class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by name: params[:name]
    # CR: [garbus] powinno byc `user&.authenticate params[:password]`
    #   `&.` Działa tylko wtedy, gdy user jest nie nil.
    #   np `data&.message` to jest jak `data.nil? && data.message`
    if user.try :authenticate, params[:password]
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: "Logged out"
  end
end
