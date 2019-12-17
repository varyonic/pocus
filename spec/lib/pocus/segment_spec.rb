# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::Segment do
  let(:session) { Pocus::Session.new(fixtures :credentials) }
  before { session.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG'] }
  let(:account) { Pocus::Account.new(session: session, account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }
  let(:list) { test_folder.lists.find_or_create_by(name: 'My First List') }

  describe '#segments.create' do
    it 'creates and deletes segments' do
      segment = test_folder.segments.create(name: 'Contacts in North Carolina', list_id: list.id)
      expect(segment).to be_kind_of(Pocus::Segment)
      expect(segment.id).to match(/^\d+$/)
      expect(segment.destroy).to be true
    end
  end
end
