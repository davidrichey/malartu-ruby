require 'spec_helper'
require 'pry'

describe Malartu::Dashboard do
  context '#find' do
    it 'makes GET request and request dashboard' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/dashboards/show.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/dashboards/abcdef?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: { 'Content-Type'=>'application/json' })
      dashboard = Malartu::Dashboard.find('abcdef')
      json = JSON.parse(res)
      expect(dashboard.sid).to eq json['sid']
      expect(dashboard.name).to eq json['name']
      expect(dashboard.snapshots.count).to eq 4
    end
  end

  context '#list' do
    it 'makes GET request and request dashboards' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/dashboards/index.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/dashboards?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res)
      dashboards = Malartu::Dashboard.list
      expect(dashboards.count).to eq 2
      json = JSON.parse(res)['dashboards'].first
      expect(dashboards.first.sid).to eq json['sid']
      expect(dashboards.first.name).to eq json['name']
      expect(dashboards.first.path).to eq json['path']
    end
  end
end
