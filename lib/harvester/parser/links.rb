module Harvester
  class Parser
    class Links < Base
      def _parse(node)
        links = LinkFinder.new(selectors, link_regex, link_validator).call(node)
        links.map {|link| after_parse(link, link[:href].strip) }.compact.uniq
      end

      def link_validator
        @link_validator ||= LinkValidator.new(schemes)
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
