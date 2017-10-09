require 'spec_helper'

describe Malartu do
  it 'has a version number' do
    expect(Malartu::VERSION).not_to be nil
  end

  it 'sets the apikey' do
    Malartu.apikey = 'apikey123'
    expect(Malartu.apikey).to eq 'apikey123'
  end

  context 'api_version' do
    it 'defaults' do
      Malartu.api_version = nil
      expect(Malartu.version).to eq 'v0'
    end

    it 'set to specific version' do
      Malartu.api_version = 'v1'
      expect(Malartu.version).to eq 'v1'
    end
  end

  context 'check_for_errors' do
    it 'raises AuthorizationError' do
      resp = double('response', code: 401, body: { test: 'me' }.to_json)
      params = { client: 'client', apikey: 'apikey' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::AuthorizationError)
    end

    it 'raises RecordNotFoundError' do
      resp = double('response', code: 404, body: { test: 'me' }.to_json)
      params = { client: 'client', apikey: 'apikey' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::RecordNotFoundError)
    end

    it 'raises ServerError' do
      resp = double('response', code: 500, body: { test: 'me' }.to_json)
      params = { client: 'client', apikey: 'apikey' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::ServerError)
    end
  end
end
