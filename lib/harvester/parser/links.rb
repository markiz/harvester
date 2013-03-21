module Harvester
  class Parser
    class Links < Base
      def _parse(node)
        link_finder.call(node).map {|link|
          after_parse(link, link[:href].strip)
        }.compact.uniq
      end

      def link_finder
        @link_finder ||= LinkFinder.new(selectors, link_regex, LinkValidator.new(schemes))
      end

      def default_options
        {
          :selectors  => "a",
          :link_regex => /.+/,
          :schemes    => ["http", "https"]
        }
      end

      def link_regex
        @link_regex ||= Array(options[:link_regex])
      end

      def schemes
        options[:schemes]
      end
    end
  end
end
