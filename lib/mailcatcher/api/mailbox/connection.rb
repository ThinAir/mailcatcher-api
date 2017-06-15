module MailCatcher
  module API
    class Mailbox
      class Connection
        def self.instance
          @@connection ||= Faraday.new(url: MailCatcher::API.config.server) do |faraday|
            faraday.request :network_exception
            faraday.adapter :net_http
          end
        end

        def self.reset!
          @@connection = nil
          self.instance
        end
      end
    end
  end
end

