require 'spec_helper'

describe Malartu::Tracking::Data do
  context '#initialize' do
    it 'defaults' do
      data = described_class.new(topic: 'topic')
      expect(data.topic).to eq 'topic'
    end

    it 'specified' do
      data = described_class.new(topic: 'topic', value: 100)
      expect(data.topic).to eq 'topic'
      expect(data.value).to eq 100
    end
  end

  context '#create' do
    it 'sends POST to url' do
      res = { id: 14, topic: 'topic', value: 100, path: '/path' }.to_json
      stub_request(:post, "#{Malartu.base_path}/kpi/tracking/data")
        .to_return(status: 201, body: res, headers: { 'Content-Type' => 'application/json'})
      data = described_class.create(topic: 'topic', value: 100)
      json = JSON.parse(res)
      expect(data.id).to eq json['id']
      expect(data.topic).to eq json['topic']
      expect(data.value).to eq json['value']
      expect(data.path).to eq json['path']
    end
  end

  context '#find' do
    it 'sends GET to url' do
      res = { id: 12, topic: 'test', value: 105, path: '/kpi/tracking/data/12' }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data/12?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: { 'Content-Type' => 'application/json'})
      data = described_class.find(12)
      expect(data.id).to eq 12
      expect(data.topic).to eq 'test'
      expect(data.value).to eq 105
      expect(data.path).to eq '/kpi/tracking/data/12'
    end
  end

  context '#list' do
    it 'sends GET to url' do
      res = { page: 1, found: 24, count: 24, limit: 25, data: [{ id: 12, topic: 'test', value: 105, path: '/kpi/tracking/data/7587' }] }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data?starting=2017-01-01&ending=2017-01-20&apikey=#{Malartu.apikey}&page=1")
        .to_return(status: 200, body: res)
      data = described_class.list(starting: '2017-01-01', ending: '2017-01-20')
      expect(data.count).to eq 1
      expect(data.first.id).to eq 12
      expect(data.first.topic).to eq 'test'
      expect(data.first.value).to eq 105
      expect(data.first.path).to eq '/kpi/tracking/data/7587'
    end

    it 'sends GET to url - paginated' do
      res = { page: 1, found: 50, count: 25, limit: 25, data: [{ id: 12, topic: 'test', value: 105, path: '/kpi/tracking/data/7587' }] }.to_json
      resend = { page: 2, found: 50, data: [{ id: 12, topic: 'test', value: 105, path: '/kpi/tracking/data/7587' }] }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data?starting=2017-01-01&ending=2017-01-20&apikey=#{Malartu.apikey}&page=1")
        .to_return(status: 200, body: res)
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data?starting=2017-01-01&ending=2017-01-20&apikey=#{Malartu.apikey}&page=2")
        .to_return(status: 200, body: resend)
      data = described_class.list(starting: '2017-01-01', ending: '2017-01-20', paginate: true)
      expect(data.count).to eq 2
    end
  end

  context '#update' do
    it 'sends PATCH to url' do
      res = { id: 15, created_at: DateTime.now, topic: 'topic', value: 100, path: '/kpi/tracking/data/15' }.to_json
      stub_request(:patch, "#{Malartu.base_path}/kpi/tracking/data/15")
        .to_return(status: 200, body: res)
      json = JSON.parse(res)
      data = described_class.update(json['id'], topic: json['topic'], value: json['value'])
      expect(data.id).to eq json['id']
      expect(data.topic).to eq json['topic']
      expect(data.value).to eq json['value']
      expect(data.path).to eq '/kpi/tracking/data/15'
    end
  end
end
