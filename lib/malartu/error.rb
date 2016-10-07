module Malartu
  module Error
    class MalartuError < StandardError
      attr_reader :message, :parameters, :json_reponse

      def initialize(message: nil, parameters: nil, json_body: nil)
        @message = message
        @parameters = parameters
        @json_body = json_body
      end
    end

    class AuthorizationError < MalartuError
    end

    class RecordNotFoundError < MalartuError
    end

    class ServerError < MalartuError
    end
  end
end
