describe ClientAuth::Signer do
  subject { signer.headers }

  before { set_config('test-api-host', 'test-app-name') }

  let(:rsa_key) { ClientAuth::Config.key.public_key.to_s }
  let(:auth) { ClientAuth::Authenticator.new(request, rsa_key) }
  let(:payload) {  }
  before {
    signer.configure(ClientAuth::Config.key, ClientAuth::Config.app_name)
    signer.payload = payload
  }

  describe '#headers' do
    let(:signer) { described_class.new('get', 'test_path') }

    its(['X-Client']) { is_expected.to eq('test-app-name') }
    its(['X-Timestamp']) { is_expected.to be_a_time_close_to Time.now.to_i }
    its(['X-Signature']) { is_expected.to be_kind_of(String) }
  end

  describe 'GET with params' do
    let(:signer) { described_class.new('get', 'test_path') }
    let(:request) { stub_get_request(signer, '/test_path?a=b') }
    let(:payload) { {a: 'b'} }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'GET without params' do
    let(:signer) { described_class.new('get', 'test_path') }
    let(:request) { stub_get_request(signer, '/test_path') }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'POST without body' do
    let(:signer) { described_class.new('post', 'test_path') }
    let(:request) { stub_request(signer, nil, 'POST') }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'POST with body' do
    let(:signer) { described_class.new('post', 'test_path') }
    let(:request) { stub_request(signer, {a: 'b'}, 'POST') }
    let(:payload) { {a: 'b'} }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'PATCH without body' do
    let(:signer) { described_class.new('patch', 'test_path') }
    let(:request) { stub_request(signer, nil, 'PATCH') }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'PATCH with body' do
    let(:signer) { described_class.new('patch', 'test_path') }
    let(:request) { stub_request(signer, {a: 'b'}, 'PATCH') }
    let(:payload) { {a: 'b'} }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'PUT without body' do
    let(:signer) { described_class.new('put', 'test_path') }
    let(:request) { stub_request(signer, nil, 'PUT') }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'PUT with body' do
    let(:signer) { described_class.new('put', 'test_path') }
    let(:request) { stub_request(signer, {a: 'b'}, 'PUT') }
    let(:payload) { {a: 'b'} }

    it { expect(auth.authenticate!).to be true }
  end

  describe 'not implemented' do
    let(:signer) { described_class.new('get', 'test_path') }

    describe 'not configure name' do
      before { signer.configure(ClientAuth::Config.key, nil) }
      it do
        expect do
          signer.headers
        end.to raise_error(NotImplementedError, 'Client name not configured') end
    end

    describe 'not configured key' do
      before { signer.configure(nil, ClientAuth::Config.app_name) }
      it do
        expect do
          signer.headers
        end.to raise_error(NotImplementedError, 'Client key not configured') end
    end
  end

  def stub_get_request(signer, path)
    double(:request, headers: signer.headers,
                     request_method: 'GET',
                     fullpath: path,
                     body: double(:request_body, read: nil))
  end

  def stub_request(signer, body, method = 'POST')
    double(:request, headers: signer.headers,
                     request_method: method,
                     fullpath: '/test_path',
                     raw_post: body,
                     body: double(:request_body, read: body && body.to_json))
  end
end
