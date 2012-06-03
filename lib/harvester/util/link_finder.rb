module Harvester
  class LinkFinder
    class <<self
      def find_matching_link(node, selectors, link_regex)
        find_matching_links(node, selectors, link_regex).first
      end

      def find_matching_links(node, selectors, link_regex)
        node.search(*selectors).
            select {|link| link[:href] &&
                           valid_url?(link[:href]) &&
                           match_any?(link[:href], link_regex) }
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
