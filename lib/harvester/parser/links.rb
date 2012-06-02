module Harvester
  class Parser
    class Links < Base
      def _parse(node)
        links = LinkFinder.find_matching_links(node, selectors, link_regex)
        links.map {|link| after_parse(link, link[:href]) }.compact.uniq
      end

      def default_options
        {
          :selectors  => "a",
          :link_regex => /.+/
        }
      end

      def link_regex
        @link_regex ||= Array(options[:link_regex])
      end
    end
  end
end
