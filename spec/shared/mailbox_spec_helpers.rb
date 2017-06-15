module MailboxSpecHelpers
  def self.included spec_class
    spec_class.class_eval do

      let(:mailbox_server) { MailCatcher::API.config.server }
      let(:mailbox) { MailCatcher::API::Mailbox.new }

      def stub_mailbox(message_count = 3)
        unstub_mailbox
        @mailbox_size = message_count

        @mailbox_email_index = FactoryGirl.build_list(:email_index, @mailbox_size).shuffle
        @stub_email_index = stub_request(:get, "#{mailbox_server}/messages")
          .to_return(status: 200, body: MultiJson.dump(@mailbox_email_index))

        @stub_email = stub_request(:get, /#{ Regexp.quote(mailbox_server) }\/messages\/\d+\.json/)
          .to_return do |request|
            {
              status: 200,
              body: MultiJson.dump(FactoryGirl.build(:email, id: request.uri.path[/\d+/]))
            }
          end

        @stub_clear_mailbox = stub_request(:delete, "#{mailbox_server}/messages")
          .to_return(status: 204, body: nil)
      end

      def unstub_mailbox
        remove_request_stub(@stub_email_index) if @stub_email_index
        remove_request_stub(@stub_email) if @stub_email
        remove_request_stub(@stub_clear_mailbox) rescue nil

        @mailbox_size = nil
        @mailbox_email_index = nil
        @stub_email_index = nil
        @stub_email = nil
      end
    end
  end
end
