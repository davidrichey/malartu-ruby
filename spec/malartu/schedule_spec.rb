require 'spec_helper'

describe Malartu::Schedule do
  context '#find' do
    it 'makes GET request and request schedule' do
      res = { uid: 'api', last_ran_at: Date.today.to_s, active: true }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/schedules/api?apikey=#{Malartu.apikey}")
        .to_return(status: 201, body: res, headers: {"Content-Type"=>"application/json"})
      sch = Malartu::Schedule.find('api')
      expect(sch.active).to eq true
      expect(sch.uid).to eq 'api'
      expect(sch.last_ran_at).to eq Date.today.to_s
      expect(sch.class).to eq Malartu::Schedule
    end
  end

  context '#list' do
    it 'makes GET request and request schedule' do
      res = { schedules: [{uid: 'api', last_ran_at: Date.today.to_s, active: true }] }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/schedules?apikey=#{Malartu.apikey}")
        .to_return(status: 201, body: res)
      schedules = Malartu::Schedule.list
      expect(schedules.count).to eq 1
      expect(schedules.first.uid).to eq 'api'
      expect(schedules.first.active).to eq true
      expect(schedules.first.last_ran_at).to eq Date.today.to_s
      expect(schedules.first.class).to eq Malartu::Schedule
    end
  end

  context '#update' do
    it 'makes GET request and request schedule' do
      res = { uid: 'api', last_ran_at: Date.today.to_s, active: true }.to_json
      stub_request(:patch, "#{Malartu.base_path}/kpi/schedules/api")
        .to_return(status: 201, body: res)
      sch = Malartu::Schedule.update('api', active: true)
      expect(sch.uid).to eq 'api'
      expect(sch.active).to eq true
      expect(sch.last_ran_at).to eq Date.today.to_s
      expect(sch.class).to eq Malartu::Schedule
    end

    it 'invalid id' do
      expect { Malartu::Schedule.update('not_api') }.to raise_error(RuntimeError)
    end
  end
end
