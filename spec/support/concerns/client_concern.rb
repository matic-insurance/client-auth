shared_examples_for 'raised 404' do
  let(:data) do
    double(:data, status: 404,
                  title: 'ClientAuth::Errors::ResourceNotFound', detail: '')
  end
  let(:json) { ClientAuth::ErrorSerializer.serialize(data) }
  let(:response) { {body: json, status: 404} }

  it { expect { request }.to raise_error(ClientAuth::Errors::ResourceNotFound) }
end

shared_examples_for 'raised 412' do
  let(:data) do
    double(:data, status: 412,
                  title: 'ClientAuth::Errors::PreconditionFailed', detail: '')
  end
  let(:json) { ClientAuth::ErrorSerializer.serialize(data) }
  let(:response) { {body: json, status: 412} }

  it { expect { request }.to raise_error(ClientAuth::Errors::PreconditionFailed) }
end

shared_examples_for 'raised 422' do
  let(:data) do
    double(:data, status: 422,
                  title: 'ClientAuth::Errors::UnprocessableEntity', detail: '')
  end
  let(:json) { ClientAuth::ErrorSerializer.serialize(data) }
  let(:response) { {body: json, status: 422} }

  it { expect { request }.to raise_error(ClientAuth::Errors::UnprocessableEntity) }
end

shared_examples_for 'raised 500' do
  let(:response) { {status: 500} }

  it { expect { request }.to raise_error(ClientAuth::Errors::ClientError) }
end

shared_examples_for 'raised 421' do
  let(:response) { {status: 421} }

  it 'returns error' do
    expect { request }.to raise_error do |error|
      expect(error).to be_a(ClientAuth::Errors::ClientError)
      expect(error.status).to eq(421)
      expect(error.message).to eq('421 Too Many Connections From This IP')
    end
  end
end
