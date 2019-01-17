# frozen_string_literal: true

module Pocus
  # Gem identity information.
  module Identity
    def self.name
      'pocus'
    end

    def self.label
      'Pocus'
    end

    def self.version
      '0.6.0'
    end

    def self.version_label
      "#{label} #{version}"
    end
  end
end
