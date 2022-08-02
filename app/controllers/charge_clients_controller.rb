require 'base64'
require 'faraday'

class ChargeClientsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :create_http_request
  before_action :prepare_request_body

  def charge
    res = @conn.post('api/charges', @payment_data)

    redirect_to payment_failure_url and return unless res.success?
    redirect_to payment_failure_url and return if res.body['state'] == 'rejected'

    redirect_to res.body['redirect_url'] and return if res.body['redirect_url'].present?

    dcc_redirect_url = res.body.dig('dcc_decision_information', 'redirect_url')
    redirect_to dcc_redirect_url and return if dcc_redirect_url.present?

    redirect_to store_index_url(locale: I18n.locale), notice: I18n.t('.thanks')
  end

  private

  def create_http_request
    @conn = Faraday.new(url: 'https://sandbox.espago.com/', headers: { Accept: 'application/vnd.espago.v3+json' }) do |f|
      f.response :json
      f.request :json
      f.adapter :net_http
      f.request :authorization, :basic, ::BASIC_AUTHORIZATION_ESPAGO['app_id'], ::BASIC_AUTHORIZATION_ESPAGO['password']
    end
  end

  def prepare_request_body
    @payment_data = {
      card: params['card_token'],
      amount: format('%0.02f', session[:order_amount]),
      currency: 'pln',
      description: "order:#{session[:order_id]}",
      positive_url: ::ESPAGO_RETURN_POSITIVE_URL,
      negative_url: ::ESPAGO_RETURN_NEGATIVE_URL
    }
  end
end
