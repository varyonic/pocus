# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::Segment do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe '#segments.create' do
    it 'creates segments' do
      list = test_folder.lists.where(name: 'My First List').first
      segment = test_folder.segments.create(name: 'Contacts in North Carolina', list_id: list.id)
      expect(segment).to be_kind_of(Pocus::Segment)
      expect(segment.id).to match(/^\d+$/)
    end
  end
end
