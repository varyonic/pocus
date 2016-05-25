# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::User do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe '#users.all' do
    it 'fetches users' do
      users = test_folder.users.all
      expect(users.first).to be_kind_of(Pocus::User)
      expect(users.first.id).to be_a(Integer)
    end
  end

  describe '#reload' do
    it 'fetches user details' do
      users = test_folder.users.all
      user = users.sample

      user.reload
      expect(user.id).to be_a(Integer)
    end
  end

  describe '#permissions.all' do
    it 'fetches permissions' do
      permissions = test_folder.users.all.sample.permissions.all
      expect(permissions.first).to be_kind_of(Pocus::Permission)
    end
  end
end
