# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::ClientFolder do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }
  let(:folder_attributes) do
    {
      name: 'iContact Corporation',
      from_name: 'John Smith',
      from_last_name: 'Smith',
      from_email: 'smith@icontact.com',
      business_name: 'Example Corp',
      street: '2635 Meridian Parkway',
      city: 'Durham',
      state: 'NC',
      postal_code: '27713',
      country: 'USA',
      phone: '8668039462',
    }
  end
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
  let(:test_list) { test_folder.lists.where(name: 'My First List').first }

  describe '#post' do
    it 'updates a client folder' do
      new_name = rand.to_s
      test_folder.business_name = new_name

      response = test_folder.post
      expect(response.warnings).to be_empty
      expect(response.business_name).to eq new_name
    end

    it 'handles errors' do
      test_folder.from_email = 'invalid'
      test_folder.post
      expect(test_folder.errors.first).to match(/fromEmail .* not valid/)
    end
  end

  describe 'lists.all' do
    it 'fetches list details' do
      response = test_folder.lists.all

      list = response.sample
      expect(list).to be_kind_of(Pocus::List)
      expect(list.list_id).to match(/^\d+$/)
    end
  end

  describe 'lists.where' do
    it 'fetches filtered lists' do
      response = test_folder.lists.where(name: 'My First List')
      expect(response.count).to eq 1

      list = response.first
      expect(list).to be_kind_of(Pocus::List)
      expect(list.list_id).to match(/^\d+$/)
    end

    it 'handles errors' do
      Pocus::Session.instance.logger = Logger.new(STDOUT)
      response = test_folder.lists.where(invalid_key: 'My First List')
      pending 'API bug, does not always include warning!'
      expect(response.warnings.count).to be > 1
    end
  end

  describe '#contacts.create' do
    it 'creates multiple contacts' do
      fields_multiple = (1..3).map do |i|
        contact_attributes.dup.merge(email: "#{i}@dummy.com")
      end
      response = test_folder.contacts.create(fields_multiple)
      expect(response.warnings).to be_empty
      contact = response.last
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
    end

    it 'handles errors' do
      fields_multiple = [1,'',2].map do |i|
        contact_attributes.dup.merge(email: "#{i}@dummy.com")
      end
      response = test_folder.contacts.create(fields_multiple)
      expect(response.warnings.count).to be > 1
      contact = response.first
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
    end
  end

  describe '#subscriptions.create' do
    it 'creates multiple subscriptions' do
      fields_multiple = (1..3).map do |i|
        contact_attributes.dup.merge(email: "#{rand(10**6)}@dummy.com")
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

  describe '#users.all' do
    it 'fetches users' do
      users = test_folder.users.all
      expect(users.first).to be_kind_of(Pocus::User)
      expect(users.first.id).to be_a(Integer)
    end
  end
end
