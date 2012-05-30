module Harvester
  class Parser
    class Link < Base
      def _parse(node)
        link = node.css(*selectors).
                  select {|link| link[:href] &&
                                 match_any?(link[:href], link_regex) }.
                  first
        if link && link[:href]
          after_parse(link, link[:href])
        end
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
    end
  end
end
