require 'spec_helper'

describe Malartu::Schedule do
  context '#find' do
    it 'makes GET request and request schedule' do
      res = { integration: 'api', timeframe: 'test', pull_date: Date.today.to_s, last_ran_at: Date.today.to_s }.to_json
      stub_request(:get, "#{Malartu.base_path}/schedule/api")
        .with(body: { client: Malartu.client, token: Malartu.token }.to_json)
        .to_return(status: 201, body: res)
      sch = Malartu::Schedule.find('api')
      expect(sch.integration).to eq 'api'
      expect(sch.timeframe).to eq 'test'
      expect(sch.pull_date).to eq Date.today.to_s
      expect(sch.last_ran_at).to eq Date.today.to_s
      expect(sch.class).to eq Malartu::Schedule
    end

    it 'invalid id' do
      expect { Malartu::Schedule.find('not_api') }.to raise_error(RuntimeError)
    end
  end

  context '#update' do
    it 'makes GET request and request schedule' do
      res = { integration: 'api', timeframe: 'monthly', pull_date: Date.today.to_s, last_ran_at: Date.today.to_s }.to_json
      stub_request(:patch, "#{Malartu.base_path}/schedule/api")
        .with(body: { timeframe: 'monthly', pull_date: Date.today.to_s, client: Malartu.client, token: Malartu.token }.to_json)
        .to_return(status: 201, body: res)
      sch = Malartu::Schedule.update('api', timeframe: 'monthly', pull_date: Date.today.to_s)
      expect(sch.integration).to eq 'api'
      expect(sch.timeframe).to eq 'monthly'
      expect(sch.pull_date).to eq Date.today.to_s
      expect(sch.last_ran_at).to eq Date.today.to_s
      expect(sch.class).to eq Malartu::Schedule
    end

    it 'invalid id' do
      expect { Malartu::Schedule.update('not_api') }.to raise_error(RuntimeError)
    end
  end
end
