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
      stub_request(:post, "#{Malartu.base_path}/trackings/metrics")
        .with(body: { topic: 'topic', value: 100, client: Malartu.client, token: Malartu.token }.to_json)
        .to_return(status: 201, body: res)
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
      stub_request(:get, "#{Malartu.base_path}/trackings/metrics/12")
        .with(body: { id: 12, model: 'Tracking::Metric', client: Malartu.client, token: Malartu.token }.to_json)
        .to_return(status: 200, body: res)
      metric = described_class.find(12)
      expect(metric.id).to eq 12
      expect(metric.topic).to eq 'test'
      expect(metric.value).to eq 105
      expect(metric.path).to eq '/trackings/metrics/12'
      expect(metric.json_body).to eq JSON.parse(res)
    end
  end

  context '#list' do
    it 'sends GET to url' do
    end
  end

  context '#update' do
    it 'sends PATCH to url' do
      res = { id: 15, created_at: DateTime.now, topic: 'topic', value: 100 }.to_json
      stub_request(:patch, "#{Malartu.base_path}/trackings/metrics/15")
        .with(body: { topic: 'topic', value: 100, client: Malartu.client, token: Malartu.token }.to_json)
        .to_return(status: 200, body: res)
      json = JSON.parse(res)
      metric = described_class.update(json['id'], topic: json['topic'], value: json['value'])
      expect(metric.id).to eq json['id']
      expect(metric.topic).to eq json['topic']
      expect(metric.value).to eq json['value']
      expect(metric.path).to eq '/trackings/metrics/15'
      expect(metric.json_body).to eq json
    end
  end

  describe Malartu::Tracking::Metric::Topic do
    context '#list' do
      it 'returns json and sets Malartu.topics' do
        res = { topics: %w(test1 test2) }.to_json
        stub_request(:get, "#{Malartu.base_path}/trackings/metrics/topics")
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
