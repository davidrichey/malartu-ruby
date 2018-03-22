module Malartu
  # A dashboard is how you display data within Malartu
  class Dashboard < MalartuObject
    attr_accessor :snapshots
    def initialize(json)
      super
      define_singleton_method('snapshots') do
        json['snapshots'].map do |c|
          Malartu::Snapshot.new(c)
        end
      end if json['snapshots']
    end

    def self.find(sid)
      res = Malartu.request('get', "/kpi/dashboards/#{sid}")
      Malartu::Dashboard.new(res)
    end

    def self.list
      res = Malartu.request('get', '/kpi/dashboards')
      res['dashboards'].map do |dashboard|
        Malartu::Dashboard.new(dashboard)
      end
    end
  end
end
