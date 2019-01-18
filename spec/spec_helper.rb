# frozen_string_literal: true

require 'bundler/setup'

require 'pocus'

Dir[File.join(File.dirname(__FILE__), 'support/extensions/**/*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'support/kit/**/*.rb')].each { |file| require file }

module Pocus
  module Fixtures
    HOME_DIR = RUBY_PLATFORM =~ /mswin32/ ? ENV['HOMEPATH'] : ENV['HOME'] unless defined?(HOME_DIR)
    LOCAL_CREDENTIALS = File.join(HOME_DIR.to_s, '.pocus/fixtures.yml') unless defined?(LOCAL_CREDENTIALS)

    def fixtures(key)
      case key
      when :credentials
        {
          app_id: ENV.fetch('POCUS_APP_ID'),
          username: ENV.fetch('POCUS_USERNAME'),
          password: ENV.fetch('POCUS_PASSWORD')
        }
      when :account_id
        ENV.fetch('POCUS_TEST_ACCOUNT')
      when :test_client_folder_id
        ENV.fetch('POCUS_TEST_CLIENT_FOLDER')
      end
    end
  end
end
