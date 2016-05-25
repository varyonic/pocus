# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::CustomField do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }

  describe '#custom_fields.create' do
    it 'creates custom fields' do
      birthdate_fields = {
        custom_field_id: :birthdate,
        field_type: :date,
        display_to_user: 1,
      }
      custom_field = test_folder.customfields.create(birthdate_fields)
      expect(custom_field).to be_a(Pocus::CustomField)
      expect(custom_field.errors).to be_empty
      expect(custom_field.warnings).to be_empty
    end
  end
end
