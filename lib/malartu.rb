require 'http'

require 'malartu/error'
require 'malartu/schedule'
require 'malartu/tracking'
require 'malartu/tracking/metric'
require 'malartu/version'

module Malartu
  API_VERSION = 'v0'.freeze
  API_PATH = 'https://www.malartu.us/'.freeze
  class << self
    attr_accessor :client, :token, :api_version, :topics

    def request(method, path, params = {}, _headers = {})
      url = "#{base_path}#{path}"
      response = HTTP.send(method, url, json: params.merge(auth_params))
      check_for_errors(response, params.merge(auth_params))
      JSON.parse(response.body)
    end

    def auth_params
      fail 'No client key present. Set it with `Malartu.client =`' if client.nil?
      fail 'No token present. Set it with `Malartu.token =`' if token.nil?
      { client: client, token: token }
    end

    def base_path
      "#{API_PATH}#{version}"
    end

    def version
      api_version || API_VERSION
    end

    def check_for_errors(response, params)
      case response.code
      when 401
        fail Malartu::Error::AuthorizationError.new(
          message: 'Credentials do not match',
          parameters: {
            client: params[:client],
            token: params[:token]
          },
          json_body: JSON.parse(response.body)
        )
      when 404
        fail Malartu::Error::RecordNotFoundError.new(
          message: 'Record Not Found',
          parameters: {
            id: params[:id],
            model: params[:model]
          },
          json_body: JSON.parse(response.body)
        )
      when 500
        fail Malartu::Error::ServerError.new(
          message: 'Server Error',
          parameters: params,
          json_body: JSON.parse(response.body)
        )
      end
    end
  end
end
