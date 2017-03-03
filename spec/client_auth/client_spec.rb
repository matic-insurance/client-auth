require 'spec_helper'

describe ClientAuth::Client do
  let(:api_host) { 'test-api-host' }
  let(:app_name) { 'test-app-name' }

  before { set_config(api_host, app_name) }

  let(:client) { described_class.new }

  let(:test_host) { "http://#{api_host}/the-path" }
  let(:path) { 'the-path' }
  let(:params) { {a: :b} }

  describe 'successful GET' do
    before { stub_request(:get, test_host).with(query: params) }
    before { client.get(path, params) }

    it 'has current headers' do
      assert_requested(:get, test_host, query: params) do |request|
        expect(request.headers['X-Client']).to eq(app_name)
        expect(request.headers['X-Timestamp']).to be_present
        expect(request.headers['X-Signature']).to be_present
      end
    end
  end

  describe 'failed GET' do
    let(:request) { client.get(path, params) }
    before { stub_request(:get, test_host).with(query: params).to_return(response) }

    it_behaves_like 'raised 404'
    it_behaves_like 'raised 412'
    it_behaves_like 'raised 500'
    it_behaves_like 'raised 421'
    it_behaves_like 'raised 422'
  end

  describe 'successful POST' do
    before { stub_request(:post, test_host) }
    before { client.post(path, params) }

    it 'has current headers' do
      assert_requested(:post, test_host) do |request|
        expect(request.headers['X-Client']).to eq(app_name)
        expect(request.headers['X-Timestamp']).to be_present
        expect(request.headers['X-Signature']).to be_present
      end
    end

    it 'has current body' do
      assert_requested(:post, test_host) do |request|
        expect(request.body).to eq('{"a":"b"}')
      end
    end
  end

  describe 'failed POST' do
    let(:request) { client.post(path, params) }
    before { stub_request(:post, test_host).to_return(response) }

    it_behaves_like 'raised 404'
    it_behaves_like 'raised 412'
    it_behaves_like 'raised 500'
    it_behaves_like 'raised 421'
    it_behaves_like 'raised 422'
  end

  describe 'successful PATCH' do
    before { stub_request(:patch, test_host) }
    before { client.patch(path, params) }

    it 'has current headers' do
      assert_requested(:patch, test_host) do |request|
        expect(request.headers['X-Client']).to eq(app_name)
        expect(request.headers['X-Timestamp']).to be_present
        expect(request.headers['X-Signature']).to be_present
      end
    end

    it 'has current body' do
      assert_requested(:patch, test_host) do |request|
        expect(request.body).to eq('{"a":"b"}')
      end
    end
  end

  describe 'failed PATCH' do
    let(:request) { client.patch(path, params) }
    before { stub_request(:patch, test_host).to_return(response) }

    it_behaves_like 'raised 404'
    it_behaves_like 'raised 412'
    it_behaves_like 'raised 500'
    it_behaves_like 'raised 421'
  end
end
