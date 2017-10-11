require 'spec_helper'

describe Malartu::Portfolio do
  context '#find' do
    it 'makes GET request and request portfolio' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/portfolio.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/portfolios/abcdef?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res, headers: {"Content-Type"=>"application/json"})
      portfolio = Malartu::Portfolio.find('abcdef')
      json = JSON.parse(res)
      expect(portfolio.sid).to eq json['sid']
      expect(portfolio.name).to eq json['name']
      json['connections'].each_with_index do |con, index|
        expect(portfolio.connections[index].access_date).to eq con['access_date']
        expect(portfolio.connections[index].company_id).to eq con['company_id']
        expect(portfolio.connections[index].metrics_path).to eq con['metrics_path']
        expect(portfolio.connections[index].state).to eq con['state']
      end
    end
  end

  context '#list' do
    it 'makes GET request and request portfolios' do
      res = File.read(File.join(File.dirname(__FILE__), '../fixtures/portfolios.json'))
      stub_request(:get, "#{Malartu.base_path}/kpi/portfolios?apikey=#{Malartu.apikey}")
        .to_return(status: 200, body: res)
      portfolios = Malartu::Portfolio.list
      json = JSON.parse(res)['portfolios'].first
      expect(portfolios.count).to eq 1
      expect(portfolios.first.sid).to eq json['sid']
      expect(portfolios.first.name).to eq json['name']
      expect(portfolios.first.path).to eq json['path']
      expect(portfolios.first.connections).to eq nil
    end
  end
end
