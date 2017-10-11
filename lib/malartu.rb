require 'http'

require 'malartu/connection'
require 'malartu/error'
require 'malartu/metric'
require 'malartu/portfolio'
require 'malartu/schedule'
require 'malartu/tracking'
require 'malartu/tracking/data'
require 'malartu/version'

module Malartu
  API_VERSION = 'v0'.freeze
  API_PATH = 'http://localhost:4000'.freeze
  # API_PATH = 'https://api.malartu.co'.freeze
  class << self
    attr_accessor :apikey, :api_version, :topics

    def request(method, path, params = {}, _headers = {})
      url = "#{base_path}#{path}"
      req_params = case method.to_s
                   when 'get'
                     { params: params.merge(auth_params) }
                   else
                     { json: params.merge(auth_params) }
                   end
      response = HTTP.send(method, url, req_params)
      check_for_errors(response, params.merge(auth_params))
      JSON.parse(response.body)
    end

    def auth_params
      fail 'No apikey present. Set it with `Malartu.apikey =`' if apikey.nil?
      { apikey: apikey }
    end

    def base_path
      "#{API_PATH}/#{version}"
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
            apikey: params[:apikey]
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
      when 429
        fail Malartu::Error::RateLimitError.new(
          message: 'Rate Limited',
          parameters: {
            apikey: params[:apikey]
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
