require 'spec_helper'

describe ClientAuth::ErrorSerializer do
  let(:error) do
    ::ClientAuth::Errors::BaseError.new('404', 'Not found')
  end

  describe '.serialize' do
    let(:json) { described_class.serialize(error) }
    let(:data) { JSON.parse(json)['errors'] }

    it { expect(data.size).to eq(1) }

    it 'serializes id and type' do
      expect(data.first['status']).to eq('404')
      expect(data.first['title']).to eq(error.class.name)
      expect(data.first['detail']).to eq('Not found')
    end
  end

  describe '.deserialize' do
    subject { described_class.deserialize(json) }
    let(:json) { described_class.serialize(error) }

    it { is_expected.to be_a(::ClientAuth::Errors::BaseError) }

    its(:status) { is_expected.to eq(error.status) }
    its(:title) { is_expected.to eq(error.title) }
    its(:detail) { is_expected.to eq(error.detail) }
  end
end
