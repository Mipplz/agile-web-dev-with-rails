require "base64"
require 'faraday'

class ChargeClientController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authorize
  before_action :create_http_request
  before_action :prepare_request_body

  def charge
    res = @conn.post('api/charges', @payment_data)
    puts res.body
    if res.success?
      redirect_to(res.body["redirect_url"]) unless res.body["redirect_url"].nil?
      # redirect_to payment_url(locale: I18n.locale), notice: 'Elo benc'
    else
      redirect_to payment_url(locale: I18n.locale), notice: 'Payment failed'
    end
  end

  private

  def create_http_request
    auth = Base64.encode64("#{::BASIC_AUTHORIZATION_ESPAGO['app_id']}:#{::BASIC_AUTHORIZATION_ESPAGO['password']}")
    @conn = Faraday.new(url: 'https://sandbox.espago.com/',
                        headers: { 'Accept' => 'application/vnd.espago.v3+json',
                                   'Authorization' => "Basic #{auth}" }) do |f|
      f.response :json
      f.adapter :net_http
    end
  end

  def prepare_request_body
    @payment_data = ""
    params["card"] = params.delete "card_token"
    params.each do |key, value|
      @payment_data += "#{key}=#{value}&"
    end
  end
end
