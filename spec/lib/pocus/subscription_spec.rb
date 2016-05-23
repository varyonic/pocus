# frozen_string_literal: true

require "spec_helper"

include Pocus::Fixtures

RSpec.describe Pocus::Subscription do
  Pocus::Session.config(fixtures(:credentials))
  Pocus::Session.instance.logger = Logger.new(STDOUT) if ENV['POCUS_DEBUG']
  let(:account) { Pocus::Account.new(account_id: fixtures(:account_id)) }
  let(:test_folder) { account.clientfolders.find(fixtures(:test_client_folder_id)) }# frozen_string_literal: true

  describe '#reload' do
    it 'fetches subscriptions details' do
      subscriptions = test_folder.subscriptions.all
      subscription = subscriptions.sample

      subscription.reload
      expect(subscription.subscription_id).to match(/^\d+_\d+$/)
    end
  end
end
