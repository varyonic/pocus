# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::Contact do
  let(:session) { Pocus::Session.new(fixtures :credentials) }
  before { session.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG'] }
  let(:account) { Pocus::Account.new(session: session, account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }
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

  describe '#contacts.create' do
    it 'creates a single contact' do
      contact = test_folder.contacts.create(email: 'single@dummy.com')
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
      expect(contact.warnings).to be_empty
    end

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
      fields_multiple = [1, '', 2].map do |i|
        contact_attributes.dup.merge(email: "#{i}@dummy.com")
      end
      response = test_folder.contacts.create(fields_multiple)
      expect(response.warnings.count).to be >= 1
      contact = response.first
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
    end
  end

  describe '#reload' do
    it 'fetches contact details' do
      contacts = test_folder.contacts.all
      contact = contacts.sample

      contact.reload
      expect(contact.id).to match(/^\d+$/)
    end
  end

  describe '#delete' do
    it 'deletes a contact' do
      contact = test_folder.contacts.create(email: 'delete.me@example.com')
      expect(contact.destroy).to be true
      expect do
        contact.reload
      end
        .to raise_error(/404/)
    end
  end
end
