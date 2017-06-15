require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end
SimpleCov.minimum_coverage 100

require 'rspec'
require 'factory_girl'
require 'webmock/rspec'

require 'bundler/setup'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mailcatcher'

RSpec.configure do |config|
  config.after(:each) do
    MailCatcher::API::Mailbox::Connection.reset!
  end
end
FactoryGirl.find_definitions
Dir[File.join(__dir__, 'shared/**/*.rb')].each { |f| require f }
