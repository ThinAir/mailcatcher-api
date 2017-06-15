# MailCatcher::API

[MailCatcher](https://github.com/sj26/mailcatcher) REST API SDK

## Installation

```ruby
# Gemfile

gem 'mailcatcher-api', '0.0.1'
```

## Configuration

If you run MailCatcher on localhost using its default 1080 port, then you can skip configuration block

```ruby
# spec/spec_helper.rb

require 'mailcatcher/api'

MailCatcher::API.configure do |config|
  config.server = 'http://127.0.0.1:1080'
end
```
## Usage

#### Integration / acceptance tests

```ruby
mailbox = MailCatcher::API::Mailbox.new
expect(mailbox.count).to be >= 1

confirmation_email = mailbox.messages.first
expect(confirmation_email.to.count).to be 1
expect(confirmation_email.to.first).to eq('user@example.com')
expect(confirmation_email.subject).to eq('User Confirmation Email')

confirmation_link = confirmation_email.links.select{ |i| i[/confirm/] }.first
confirmation_code = confirmation_link.split('/').last

post '/api/account/confirm.json', JSON.dump('confirmation_token' => confirmation_code)
expect(last_response.status).to be 200
```

#### Available email attributes

```ruby
mailbox = MailCatcher::API::Mailbox.new
email = mailbox.messages.first

email.raw
email.message_id
email.date

email.from
email.to
email.subject
email.body

email.mime_type
emai.charset
emai.content_type

emai.links

# Delete a specific message:
email.delete

# Clear all messages in the mailbox:
mailbox.clear
```

## Running Tests

After cloning the repository:

```bash
bundle install
bundle exec rspec
```

NOTE: Test coverage is required to be at 100%.

## TODO

* Implement CollectionProxy for the mailbox messages similar to ActiveRecord.

    And support such methods:

    ```ruby
    mailbox.find(<attr>: '')
    mailbox.find(<attr>: //)
    ```

    Where `attr` could be
    * from
    * to
    * subject
    * link

* Support attachments

## Copyright

Copyright (c) 2014 Andrii Vakarev and Contributors. See LICENSE for details.
