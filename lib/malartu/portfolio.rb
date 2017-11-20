module Malartu
  # A portfolio is how groups track companies within Malartu
  class Portfolio < MalartuObject
    attr_accessor :connections, :path
    def initialize(json)
      super
      define_singleton_method('connections') do
        json['connections'].map do |c|
          Malartu::Connection.new(c)
        end
      end if json['connections']
      define_singleton_method('path') { json['path'] || "/v0/kpi/portfolios/#{sid}" }
    end

    def self.find(sid)
      res = Malartu.request('get', "/kpi/portfolios/#{sid}")
      Malartu::Portfolio.new(res)
    end

    def self.list
      res = Malartu.request('get', '/kpi/portfolios')
      res['portfolios'].map do |schedule|
        Malartu::Portfolio.new(schedule)
      end
    end
  end
end
