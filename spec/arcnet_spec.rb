require 'spec_helper'

describe Malartu do
  it 'has a version number' do
    expect(Malartu::VERSION).not_to be nil
  end

  it 'sets the client' do
    Malartu.client = 'client123'
    expect(Malartu.client).to eq 'client123'
  end

  it 'sets the token' do
    Malartu.token = 'token123'
    expect(Malartu.token).to eq 'token123'
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
      params = { client: 'client', token: 'token' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::AuthorizationError)
    end

    it 'raises RecordNotFoundError' do
      resp = double('response', code: 404, body: { test: 'me' }.to_json)
      params = { client: 'client', token: 'token' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::RecordNotFoundError)
    end

    it 'raises ServerError' do
      resp = double('response', code: 500, body: { test: 'me' }.to_json)
      params = { client: 'client', token: 'token' }
      expect do
        described_class.check_for_errors(resp, params)
      end.to raise_error(Malartu::Error::ServerError)
    end
  end
end
