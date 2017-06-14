require_relative '../../spec_helper'

describe MailCatcher::API::Mailbox do
  include MailboxSpecHelpers

  describe 'stubbed' do
    before do
      stub_mailbox
    end
    after do
      remove_request_stub(@stub) if @stub
      unstub_mailbox
    end

    describe '#messages' do
      it 'without reload' do
        expect(mailbox.messages.count).to be @mailbox_size
        mailbox.messages.each do |msg|
          expect(msg).to be_an_instance_of(MailCatcher::API::Mailbox::Message)
        end
        assert_requested(:get, "#{mailbox_server}/messages", times: 1)
        @mailbox_email_index.each do |item|
          assert_requested(:get, "#{mailbox_server}/messages/#{item['id']}.json", times: 1)
        end
      end

      it 'with reload' do
        old_mailbox_size = @mailbox_size
        expect(mailbox.messages.count).to be old_mailbox_size
        unstub_mailbox
        new_mailbox_size = old_mailbox_size + 1
        stub_mailbox(new_mailbox_size)
        expect(mailbox.messages.count).to be old_mailbox_size
        expect(mailbox.messages(reload: true).count).to be new_mailbox_size
      end
    end

    it '#count' do
      expect(mailbox.messages.count).to be @mailbox_size
    end

    describe '#delete' do
    end
  end
end
