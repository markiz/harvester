require 'addressable/uri'

module Harvester
  class Parser
    class Link < Base
      def _parse(node)
        link = find_matching_link(node)
        after_parse(link, link[:href]) if link
      end

      def default_options
        {
          :selectors => "a"
        }
      end

      def find_matching_link(node)
        find_matching_links(node).first
      end

      def find_matching_links(node)
        node.css(*selectors).
            select {|link| link[:href] &&
                           valid_url?(link[:href]) &&
                           match_any?(link[:href], link_regex) }
      end

      def link_regex
        @link_regex ||= Array(options[:link_regex])
      end

      def match_any?(string, regex)
        regex.any? {|r| r =~ string }
      end

      def valid_url?(url)
        ["http", "https", nil].include?(Addressable::URI.parse(url).scheme)
      rescue Addressable::URI::InvalidURIError
        false
      end
    end
  end
end
