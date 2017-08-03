require 'faraday'
require 'multi_json'

require 'mailcatcher/api/version'
require 'mailcatcher/api/configuration'
require 'mailcatcher/api/error'
require 'mailcatcher/api/middleware/network_exceptions'
require 'mailcatcher/api/mailbox/connection'
require 'mailcatcher/api/mailbox'

module MailCatcher
  module API
    class << self
      attr_accessor :config
    end

    def self.config
      @configuration ||= Configuration.new
    end

    def self.reset_config
      @configuration = Configuration.new
    end

    def self.configure
      yield(config)
    end
  end
end
