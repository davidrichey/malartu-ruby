module Malartu
  class MalartuObject
    attr_accessor :json
    def initialize(json)
      json.each do |k, v|
        define_singleton_method(k) { v }
      end
      @json = json
    end
  end
end
