module Malartu
  # A schedule is what tells Malartu when to aggregate the data
  # Learn more at: TODO
  class Schedule
    attr_accessor :integration, :timeframe, :pull_date, :last_ran_at, :json_body
    def initialize(integration, timeframe, pull_date, last_ran_at, json_body)
      @integration = integration
      @timeframe = timeframe
      @pull_date = pull_date
      @last_ran_at = last_ran_at
      @json_body = json_body
    end

    def self.find(id = 'api')
      fail 'Invalid ID' unless id == 'api'
      res = Malartu.request('get', "/schedule/#{id}")
      Malartu::Schedule.new(res['integration'], res['timeframe'], res['pull_date'], res['last_ran_at'], res)
    end

    def self.update(id = 'api', timeframe: nil, pull_date: nil)
      fail 'Invalid ID' unless id == 'api'
      params = {}
      params[:timeframe] = timeframe unless timeframe.nil?
      params[:pull_date] = pull_date unless timeframe.nil?
      res = Malartu.request('patch', "/schedule/#{id}", params)
      Malartu::Schedule.new(res['integration'], res['timeframe'], res['pull_date'], res['last_ran_at'], res)
    end
  end
end
