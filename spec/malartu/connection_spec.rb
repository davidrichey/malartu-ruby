require 'spec_helper'

describe Malartu::Schedule do
  context '#list' do
    it 'makes GET request and lists connections' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/connections.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/connections?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: {"Content-Type"=>"application/json"})
      connections = Malartu::Connection.list
      expect(connections.count).to eq 1
    end
  end

  context '#metrics' do
    it 'makes GET request and lists metrics' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/connection/metrics.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/connections/1/metrics?apikey=#{Malartu.apikey}&end_date=2017-09-10&timezone=America/New_York&uids=accounts_payable")
        .to_return(status: 200, body: res, headers: {"Content-Type"=>"application/json"})
      metrics = Malartu::Connection.metrics(1, ending: '2017-09-10', timezone: "America/New_York", uids: ['accounts_payable'])
      expect metrics == JSON.parse(res)
    end
  end
end
