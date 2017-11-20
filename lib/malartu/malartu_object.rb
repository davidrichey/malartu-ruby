module Malartu
  class MalartuObject
    attr_accessor :json
    def initialize(json)
      json.each do |k, v|
        define_singleton_method(k) { v }
      end
      @json = json
    end

    def self.paginate?(response)
      page = response['page'].to_i
      limit = response['limit'].to_i
      found = response['found'].to_i
      count = response['count'].to_i
      ((page - 1) * limit) + count < found
    end
  end
end
