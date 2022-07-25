require "base64"
require 'faraday'

class ChargeClientController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authorize
  before_action :create_http_request
  before_action :prepare_request_body

  def charge
    res = @conn.post('api/charges', @payment_data)

    redirect_to payment_failure_url and return unless res.success?
    redirect_to payment_failure_url and return if res.body["state"] == 'rejected'

    redirect_to res.body["redirect_url"] and return if res.body["redirect_url"].present?

    dcc_redirect_url = res.body.dig("dcc_decision_information", "redirect_url")
    redirect_to dcc_redirect_url and return if dcc_redirect_url.present?

    redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks')
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
