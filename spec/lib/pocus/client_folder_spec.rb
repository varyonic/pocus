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
end
