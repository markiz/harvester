require 'addressable/uri'

module Harvester
  class Parser
    class Link < Base
      def _parse(node)
        link = LinkFinder.find_matching_link(node, selectors, link_regex)
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
    end
  end
end
