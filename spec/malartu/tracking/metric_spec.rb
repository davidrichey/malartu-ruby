require 'spec_helper'

describe Malartu::Tracking::Metric do
  context '#initialize' do
    it 'defaults' do
      metric = described_class.new(topic: 'topic')
      expect(metric.topic).to eq 'topic'
      expect(metric.value).to eq 1
      expect(metric.json_body).to eq nil
    end

    it 'specified' do
      metric = described_class.new(topic: 'topic', value: 100)
      expect(metric.topic).to eq 'topic'
      expect(metric.value).to eq 100
      expect(metric.json_body).to eq nil
    end
  end

  context '#create' do
    it 'sends POST to url' do
      res = { id: 14, topic: 'topic', value: 100, path: '/path' }.to_json
      stub_request(:post, "#{Malartu.base_path}/kpi/tracking/data")
        .to_return(status: 201, body: res, headers: { 'Content-Type' => 'application/json'})
      metric = described_class.create(topic: 'topic', value: 100)
      json = JSON.parse(res)
      expect(metric.id).to eq json['id']
      expect(metric.topic).to eq json['topic']
      expect(metric.value).to eq json['value']
      expect(metric.path).to eq json['path']
      expect(metric.json_body).to eq JSON.parse(res)
    end
  end

  context '#find' do
    it 'sends GET to url' do
      res = { id: 12, topic: 'test', value: 105 }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data/12?model=Tracking::Metric&apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: { 'Content-Type' => 'application/json'})
      metric = described_class.find(12)
      expect(metric.id).to eq 12
      expect(metric.topic).to eq 'test'
      expect(metric.value).to eq 105
      expect(metric.path).to eq '/kpi/tracking/data/12'
      expect(metric.json_body).to eq JSON.parse(res)
    end
  end

  context '#list' do
    it 'sends GET to url' do
      res = { metrics: [{ id: 12, topic: 'test', value: 105, path: '/kpi/tracking/data/7587' }] }.to_json
      stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data?starting=2017-01-01&ending=2017-01-20&apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res)
      metrics = described_class.list('2017-01-01', '2017-01-20')
      expect(metrics.count).to eq 1
      expect(metrics.first.id).to eq 12
      expect(metrics.first.topic).to eq 'test'
      expect(metrics.first.value).to eq 105
      expect(metrics.first.path).to eq '/kpi/tracking/data/7587'
      expect(metrics.first.json_body).to eq JSON.parse(res)['metrics'].first
    end
  end

  context '#update' do
    it 'sends PATCH to url' do
      res = { id: 15, created_at: DateTime.now, topic: 'topic', value: 100 }.to_json
      stub_request(:patch, "#{Malartu.base_path}/kpi/tracking/data/15")
        .to_return(status: 200, body: res)
      json = JSON.parse(res)
      metric = described_class.update(json['id'], topic: json['topic'], value: json['value'])
      expect(metric.id).to eq json['id']
      expect(metric.topic).to eq json['topic']
      expect(metric.value).to eq json['value']
      expect(metric.path).to eq '/kpi/tracking/data/15'
      expect(metric.json_body).to eq json
    end
  end

  describe Malartu::Tracking::Metric::Topic do
    context '#list' do
      it 'returns json and sets Malartu.topics' do
        res = { topics: %w(test1 test2) }.to_json
        stub_request(:get, "#{Malartu.base_path}/kpi/tracking/data/topics?apikey=#{Malartu.apikey}")
          .to_return(status: 200, body: res)
        json = JSON.parse(res)
        topics = described_class.list
        expect(topics).to eq json['topics']
        expect(Malartu.topics).to eq json['topics']
      end

      it 'is already set' do
        Malartu.topics = %w(test11 test12)
        topics = described_class.list
        expect(topics).to eq %w(test11 test12)
      end
    end
  end
end
