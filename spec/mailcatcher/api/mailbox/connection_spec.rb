require 'spec_helper'

describe MailCatcher::API::Mailbox::Connection do
  describe '.instance' do
    context 'the first time' do
      before do
        expect(Faraday).to receive(:new).with(url: 'http://127.0.0.1:1080').and_call_original
      end
      it 'returns a new, configured faraday connection' do
        expect(described_class.instance).to be_a Faraday::Connection
      end
    end
    context 'after the first time' do
      before do
        @fake_faraday = :fake
        expect(Faraday).to receive(:new).with(url: 'http://127.0.0.1:1080').and_return(@fake_faraday)
        @original_faraday = described_class.instance
        expect(Faraday).not_to receive(:new)
      end
      it 'returns the existing faraday connection' do
        expect(described_class.instance).to eq(@original_faraday)
      end
    end
  end

  describe '.reset!' do
    before do
      @instance = described_class.instance
    end
    it 'removes the current instance' do
      described_class.reset!
      expect(described_class.instance).not_to eq(@instance)
    end
  end
end
