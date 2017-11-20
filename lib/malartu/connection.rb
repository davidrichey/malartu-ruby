module Malartu
  # A connection is what ties together a company and a portfolios
  class Connection < MalartuObject
    def self.list
      res = Malartu.request('get', '/kpi/connections')
      res['connections'].map do |connection|
        Malartu::Schedule.new(connection)
      end
    end

    def self.metrics(id, starting: nil, ending: DateTime.now.to_s, grain: nil, timezone: "UTC", uids: [])
      uids = uids.join(',')
      params = {
        start_date: starting,
        end_date: ending,
        grain: grain,
        timezone: timezone,
        uids: uids
      }.select { |_, value| !value.nil? }
      Malartu.request('get', "/kpi/connections/#{1}/metrics", params)
    end
  end
end
