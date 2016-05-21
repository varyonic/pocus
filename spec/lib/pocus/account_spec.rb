# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::Account do
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

  describe '.associations' do
    it 'stores configuration options' do
      expect(Pocus::Account.associations).to eq Hash[clientfolders: { path: '/c', class: 'ClientFolder'} ]
      expect(Pocus::Account.new({}).clientfolders).to be_kind_of(Pocus::Association)
    end
  end

  describe '#reload' do
    it 'fetches account details' do
      response = account.reload
      expect(response.errors).to be_empty
      expect(response.warnings).to be_empty
      expect(response).to eq(account)
    end
  end

  describe '#get_clientfolder' do
    it 'fetches a single folder identified by id' do
      response = account.get_clientfolder(fixtures(:test_client_folder_id))
      expect(response.warnings).to be_nil

      folder = response.clientfolder
      expect(folder).to be_kind_of(Pocus::ClientFolder)
      expect(folder.client_folder_id).to match(/^\d+$/)
      expect(folder.parent).to eq account
      expect(folder.session).to eq account.session
    end

    it 'handles errors' do
      expect do
        account.get_clientfolder(0).inspect
      end
      .to raise_error(/Unexpected response/)
    end
  end

  describe '#clientfolders.all' do
    it 'fetches all folder details' do
      response = account.clientfolders.all
      expect(response.warnings).to be_nil
      expect(response.clientfolders.count).to be >= 1

      folder = response.clientfolders.last
      expect(folder).to be_kind_of(Pocus::ClientFolder)
      expect(folder.client_folder_id).to match(/^\d+$/)
    end
  end
end
