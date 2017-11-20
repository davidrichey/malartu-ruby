module Malartu
  # Metrics is how Malartu tracks data from various sources
  class Metric < MalartuObject
    def self.uids
      Malartu.request('get', '/kpi/metric/uids')['valid_metric_uids']
    end

    def self.list(starting: nil, ending: Date.today.to_s, grain: nil, timezone: 'UTC', uids: [])
      uids = uids.join(',')
      params = {
        start_date: starting,
        end_date: ending,
        grain: grain,
        timezone: timezone,
        uids: uids
      }.select { |_, value| !value.nil? }
      Malartu.request('get', '/kpi/metrics', params)
    end
  end
end
