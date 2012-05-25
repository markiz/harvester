module Harvester
  class Parser
    class Link < Base
      def parse(node)
        links = node.css(*selectors).select {|link| link[:href] && match_any?(link[:href], link_regex) }
        {
          name => links.first[:href]
        }
      end

      def link_regex
        @link_regex ||= Array(options[:link_regex])
      end

      def match_any?(string, regex)
        regex.any? {|r| r.match(string) }
      end
    end
  end
end
