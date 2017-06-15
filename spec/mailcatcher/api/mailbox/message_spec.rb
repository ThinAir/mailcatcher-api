require 'spec_helper'

describe MailCatcher::API::Mailbox::Message do

  def remove_carriage_chars(str)
    str.tr("\r", '').tr("\n", '')
  end

  let(:msg_class) { MailCatcher::API::Mailbox::Message }

  it 'has attributes' do
    msg = msg_class.new('mail raw source')
    expect(msg).to respond_to :id
    expect(msg).to respond_to :raw
    expect(msg).to respond_to :message_id
    expect(msg).to respond_to :date

    expect(msg).to respond_to :from
    expect(msg).to respond_to :to
    expect(msg).to respond_to :subject
    expect(msg).to respond_to :body

    expect(msg).to respond_to :mime_type
    expect(msg).to respond_to :charset
    expect(msg).to respond_to :content_type

    expect(msg).to respond_to :links

    expect(msg).to respond_to :delete
  end

  it 'initializable' do
    email = FactoryGirl.build(:email)
    msg = msg_class.new(email)

    expect(msg.id).to eq(email['id'])
    expect(msg.raw).to eq(email['source'])
    expect(msg.message_id).to eq(email['message_id'])
    expect(msg.date).to eq(email['date'])

    expect(msg.from).to eq(email['from'])
    expect(msg.to).to eq(email['to'])
    expect(msg.subject).to eq(email['subject'])
    expect(remove_carriage_chars(msg.body)).to eq(remove_carriage_chars(email['body']))

    expect(msg.mime_type).to eq(email['mime_type'])
    expect(msg.charset).to eq(email['charset'])
    expect(msg.content_type).to eq(email['content_type'])

    expect(msg.links).to eq(email['links'])
  end
end
