module Malartu
  # A snapshot is saved from a dashboard at a certain period in time
  class Snapshot < MalartuObject
    attr_accessor :snapshots
    def self.find(sid, dashboard_sid)
      res = Malartu.request('get', "/kpi/dashboards/#{dashboard_sid}/snapshots/#{sid}")
      Malartu::Snapshot.new(res)
    end

    def self.list(dashboard_sid)
      res = Malartu.request('get', "/kpi/dashboards/#{dashboard_sid}")
      res['snapshots'].map do |snapshot|
        Malartu::Snapshot.new(snapshot)
      end
    end
  end
end
