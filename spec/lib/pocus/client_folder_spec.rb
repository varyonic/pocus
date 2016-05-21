# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::ClientFolder do
  Pocus::Session.config(fixtures(:credentials))
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.get_clientfolder(fixtures(:test_client_folder_id)).clientfolder }
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

  describe '#get_lists' do
    it 'fetches list details' do
      response = test_folder.get_lists

      list = response.lists.sample
      expect(list).to be_kind_of(Pocus::List)
      expect(list.list_id).to match(/^\d+$/)
    end
  end

  describe '#post_contacts' do
    it 'creates multiple contacts' do
      Pocus::Session.instance.logger = Logger.new(STDOUT)
      contacts = (1..3).map do |i|
        Pocus::Contact.new(contact_attributes.merge(email: "#{i}@dummy.com"))
      end
      response = test_folder.post_contacts(contacts)
      expect(response.warnings).to be_nil
      contact = response.contacts.last
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
    end

    it 'handles errors' do
      Pocus::Session.instance.logger = Logger.new(STDOUT)
      contacts = [1,'',2].map do |i|
        Pocus::Contact.new(contact_attributes.merge(email: "#{i}@dummy.com"))
      end
      response = test_folder.post_contacts(contacts)
      expect(response.warnings.count).to be > 1
      contact = response.contacts.first
      expect(contact).to be_kind_of(Pocus::Contact)
      expect(contact.contact_id).to match(/^\d+$/)
    end

  end
end
