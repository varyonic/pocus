# frozen_string_literal: true

require 'spec_helper'

include Pocus::Fixtures

RSpec.describe Pocus::CustomField do
  let(:session) { Pocus::Session.new(fixtures :credentials) }
  before { session.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG'] }
  let(:account) { Pocus::Account.new(session: session, account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe '#custom_fields.create' do
    it 'creates custom fields' do
      birthdate_fields = {
        private_name: rand.to_s,
        field_type: :date,
        display_to_user: 1
      }
      custom_field = test_folder.customfields.create(birthdate_fields)
      expect(custom_field).to be_a(Pocus::CustomField)
      expect(custom_field.errors).to be_empty
      expect(custom_field.warnings).to be_empty
      custom_field.destroy
    end
  end
end
