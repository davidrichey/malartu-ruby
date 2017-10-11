require 'spec_helper'

describe Malartu::Schedule do
  context '#uids' do
    it 'makes GET request and lists valid uids' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/metrics/uids.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/metric/uids?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: {"Content-Type"=>"application/json"})
      uids = Malartu::Metric.uids
      expect(uids).to eq JSON.parse(res)['valid_metric_uids']
    end
  end

  context '#list' do
    it 'makes GET request and lists metrics' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/metrics.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/metrics?apikey=#{Malartu.apikey}&end_date=2017-09-10&timezone=America/New_York&uids=accounts_payable")
        .to_return(status: 200, body: res, headers: {"Content-Type"=>"application/json"})
      metrics = Malartu::Metric.list(ending: '2017-09-10', timezone: "America/New_York", uids: ['accounts_payable'])
      expect metrics == JSON.parse(res)
    end
  end
end
