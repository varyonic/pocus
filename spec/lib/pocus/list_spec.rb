# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::List do
  let(:session) { Pocus::Session.new(fixtures :credentials) }
  before { session.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG'] }
  let(:account) { Pocus::Account.new(session: session, account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe 'lists.all' do
    it 'fetches list details' do
      response = test_folder.lists.all

      list = response.sample
      expect(list).to be_kind_of(Pocus::List)
      expect(list.list_id).to match(/^\d+$/)
    end
  end

  describe 'lists.where' do
    before do
      @lists = test_folder.lists.create(name: "Random list #{random_name(12)}")
    end

    after do
      Array(@lists).each(&:delete)
    end

    it 'fetches filtered lists' do
      response = test_folder.lists.where(name: 'My First List')
      expect(response.count).to eq 1

      list = response.first
      expect(list).to be_kind_of(Pocus::List)
      expect(list.list_id).to match(/^\d+$/)
    end

    it 'returns empty set if no match' do
      response = test_folder.lists.where(name: 'non-existant')
      expect(response.count).to eq 0
    end

    it 'handles errors' do
      session.logger = Logger.new(STDOUT)
      response = test_folder.lists.where(invalid_key: 'My First List')
      pending 'API bug, does not always include warning!'
      expect(response.warnings.count).to be > 1
    end
  end

  describe '#reload' do
    it 'fetches list details' do
      lists = test_folder.lists.all
      list = lists.sample

      list.reload
      expect(list.id).to match(/^\d+$/)
    end
  end
end
