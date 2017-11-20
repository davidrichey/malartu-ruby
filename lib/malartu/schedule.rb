module Malartu
  # A schedule is what tells Malartu when to aggregate the data
  class Schedule < MalartuObject
    def self.find(id = 'api')
      res = Malartu.request('get', "/kpi/schedules/#{id}")
      Malartu::Schedule.new(res)
    end

    def self.list
      res = Malartu.request('get', '/kpi/schedules')
      res['schedules'].map do |schedule|
        Malartu::Schedule.new(schedule)
      end
    end

    def self.update(id = 'api', active: false)
      fail 'Invalid ID' unless id == 'api'
      params = {}
      params[:active] = active unless active.nil?
      res = Malartu.request('patch', "/kpi/schedules/#{id}", params)
      Malartu::Schedule.new(res)
    end
  end
end
