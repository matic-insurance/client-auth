describe ClientAuth::Authenticator do
  subject { authenticate }
  let(:authenticate) { described_class.new(request, rsa_key).authenticate! }

  let(:request_method) { 'GET' }
  let(:client_name) { 'client_name' }
  let(:fullpath) { '/anonymous' }
  let(:body) { double(:request_body, read: '') }
  let(:timestamp) { 9.minutes.ago.to_i }
  let(:singer) { ClientAuth::Signer.new(request_method, '/anonymous', test: 'yes') }
  let(:secret_string) { singer.send(:secret_string) }

  let(:rsa_key) { public_key }
  let(:signature) { make_signature(rsa_key, secret_string) }

  let(:request) do
    double(:request, headers: headers,
           request_method: request_method,
           fullpath: fullpath,
           body: body)
  end

  let(:headers) do
    {
        'X-Client' => client_name,
        'X-Timestamp' => timestamp,
        'X-Signature' => signature
    }
  end

  before do
    allow(singer).to receive(:client_name).and_return(client_name)
  end
  before { allow(singer).to receive(:timestamp).and_return(timestamp) }

  describe 'success GET authentication' do
    let(:fullpath) { '/anonymous?test=yes' }
    it { is_expected.to be true }
  end

  describe 'success POST authentication' do
    let(:request_method) { 'POST' }
    let(:body) { double(:request_body, read: '{"test":"yes"}') }

    it { is_expected.to be true }
  end

  describe 'success body-less authentication' do
    let(:fullpath) { '/anonymous?test=yes' }
    let(:body) { double(:request_body, read: nil) }

    it { is_expected.to be_truthy }
  end

  context 'without client name' do
    let(:client_name) { nil }

    it { expect { authenticate }.to raise_authentication_error 'No client name' }
  end

  context 'without timestamp' do
    let(:timestamp) { nil }

    it { expect { authenticate }.to raise_authentication_error 'No timestamp' }
  end

  context 'with stale timestamp' do
    let(:timestamp) { 11.minutes.ago.to_i }

    it { expect { authenticate }.to raise_authentication_error 'Timestamp is expired' }
  end

  context 'without signature' do
    let(:signature) { nil }

    it { expect { authenticate }.to raise_authentication_error 'Signature is missing' }
  end

  context 'with incorrect signature' do
    let(:signature) { '123' }

    it { expect { authenticate }.to raise_authentication_error 'Invalid signature' }
  end
end
