module Malartu
  # A schedule is what tells Malartu when to aggregate the data
  class Schedule
    attr_accessor :active, :uid, :last_ran_at, :json_body
    def initialize(active, uid, last_ran_at, json_body)
      @active = active
      @uid = uid
      @last_ran_at = last_ran_at
      @json_body = json_body
    end

    def self.find(id = 'api')
      res = Malartu.request('get', "/kpi/schedules/#{id}")
      Malartu::Schedule.new(res['active'], res['uid'], res['last_ran_at'], res)
    end

    def self.list
      res = Malartu.request('get', '/kpi/schedules')
      puts res
      res['schedules'].map do |schedule|
        Malartu::Schedule.new(
          schedule['active'],
          schedule['uid'],
          schedule['last_ran_at'],
          schedule
        )
      end
    end

    def self.update(id = 'api', active: false)
      fail 'Invalid ID' unless id == 'api'
      params = {}
      params[:active] = active unless active.nil?
      res = Malartu.request('patch', "/kpi/schedules/#{id}", params)
      Malartu::Schedule.new(res['active'], res['uid'], res['last_ran_at'], res)
    end
  end
end
