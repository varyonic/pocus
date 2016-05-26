# frozen_string_literal: true

require 'bundler/setup'

if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'pocus'

Dir[File.join(File.dirname(__FILE__), 'support/extensions/**/*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'support/kit/**/*.rb')].each { |file| require file }

module Pocus
  module Fixtures
    HOME_DIR = RUBY_PLATFORM =~ /mswin32/ ? ENV['HOMEPATH'] : ENV['HOME'] unless defined?(HOME_DIR)
    LOCAL_CREDENTIALS = File.join(HOME_DIR.to_s, '.pocus/fixtures.yml') unless defined?(LOCAL_CREDENTIALS)

    def all_fixtures
      @@fixtures ||= load_fixtures
    end

    def fixtures(key)
      data = all_fixtures[key] || fail(StandardError, "No fixture data was found for '#{key}'")
      data.dup
    end

    def load_fixtures
      [LOCAL_CREDENTIALS].inject({}) do |credentials, file_name|
        if File.exist?(file_name)
          yaml_data = YAML.load(File.read(file_name))
          credentials.merge!(symbolize_keys(yaml_data))
        end
        credentials
      end
    end

    def symbolize_keys(hash)
      return hash unless hash.is_a?(Hash)
      hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = symbolize_keys(v) }
    end
  end
end
