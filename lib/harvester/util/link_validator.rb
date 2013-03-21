require 'addressable/uri'
module Harvester
  class LinkValidator
    attr_reader :schemes
    def initialize(schemes)
      @schemes = Array(schemes)
    end

    def call(href)
      addressable = Addressable::URI.parse(href)
      valid_url?(addressable) && valid_scheme?(addressable) && valid_host?(addressable)
    rescue Addressable::URI::InvalidURIError
      false
    end
    alias_method :valid?, :call

    def valid_url?(addressable)
      !!addressable.to_s
    end

    def valid_scheme?(addressable)
      addressable.scheme.nil? || schemes.include?(addressable.scheme)
    end

    def valid_host?(addressable)
      addressable.host.nil? || addressable.host.include?('.')
    end
  end
end
