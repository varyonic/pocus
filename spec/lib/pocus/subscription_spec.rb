# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::Subscription do
  let(:session) { Pocus::Session.new(fixtures :credentials) }
  before { session.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG'] }
  let(:account) { Pocus::Account.new(session: session, account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) } # frozen_string_literal: true
  let(:test_list) { test_folder.lists.find_or_create_by(name: 'My First List') }
  let(:contact_attributes) do
    {
      prefix: 'Miss',
      first_name: 'Mary',
      last_name: 'Smith',
      suffix: 'III',
      street: '2635 Meridian Parkway',
      street2: 'Suite 100',
      city: 'Durham',
      state: 'NC',
      postal_code: '27713',
      phone: '8668039462',
      fax: '8668039462',
      business: '8668039462'
    }
  end

  describe '#subscriptions.create' do
    it 'creates multiple subscriptions' do
      fields_multiple = (1..3).map do |_i|
        contact_attributes.dup.merge(email: "#{random_name(8)}@dummy.com")
      end
      contacts = test_folder.contacts.create(fields_multiple)
      subscription_fields = contacts.map do |contact|
        Hash[contact_id: contact.id, list_id: test_list.id, status: :normal]
      end
      subscriptions = test_folder.subscriptions.create(subscription_fields)
      expect(subscriptions.size).to eq 3

      subscription = subscriptions.first
      expect(subscription).to be_a(Pocus::Subscription)
      expect(subscription.subscription_id).to match(/^\d+_\d+$/)
    end
  end

  describe '#reload' do
    it 'fetches subscriptions details' do
      subscriptions = test_folder.subscriptions.all
      subscription = subscriptions.sample

      subscription.reload
      expect(subscription.subscription_id).to match(/^\d+_\d+$/)
    end
  end
end
