require 'spec_helper'
require 'pry'

describe Malartu::Snapshot do
  context '#find' do
    it 'makes GET request and request dashboard' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/snapshots/show.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/dashboards/20/snapshots/abcdef?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: { 'Content-Type'=>'application/json' })
      snapshot = Malartu::Snapshot.find('abcdef', 20)
      json = JSON.parse(res)
      expect(snapshot.sid).to eq json['sid']
      expect(snapshot.name).to eq json['name']
      expect(snapshot.public).to eq json['public']
      expect(snapshot.data).to eq json['data']
    end
  end

  context '#list' do
    it 'makes GET request and request snapshots' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/dashboards/show.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/dashboards/abcdef?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res)
      snapshots = Malartu::Snapshot.list('abcdef')
      expect(snapshots.count).to eq 4
      json = JSON.parse(res)['snapshots'].first
      expect(snapshots.first.name).to eq json['name']
      expect(snapshots.first.reported_at).to eq json['reported_at']
      expect(snapshots.first.path).to eq json['path']
    end
  end
end
