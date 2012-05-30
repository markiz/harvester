require 'uri'

module Harvester
  class Parser
    class Link < Base
      def _parse(node)
        link = node.css(*selectors).
                  select {|link| link[:href] &&
                                 valid_url?(link[:href]) &&
                                 match_any?(link[:href], link_regex) }.
                  first
        after_parse(link, link[:href]) if link
      end

      def default_options
        {
          :selectors => "a"
        }
      end

      def link_regex
        @link_regex ||= Array(options[:link_regex])
      end

      def match_any?(string, regex)
        regex.any? {|r| r =~ string }
      end

      def valid_url?(url)
        @@http_regexp ||= URI.regexp(['http', 'https'])
        url.match(@@http_regexp).begin(0) == 0
      end
    end
  end
end
