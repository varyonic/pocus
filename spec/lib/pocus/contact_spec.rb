# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::Contact do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe '#reload' do
    it 'fetches contact details' do
      contacts = test_folder.contacts.all
      contact = contacts.sample

      contact.reload
      expect(contact.id).to match(/^\d+$/)
    end
  end
end