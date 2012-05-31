module Harvester
  class Parser
    class Date < Base
      def _parse(node)
        node.css(*selectors).map do |checked_node|
          if (match = match_any(checked_node.text, regex))
            DateParser.parse(match[regex_capture_group], locale)
          end
        end.compact.first
      end

      def default_options
        {
          :regex               => %r%(\d{2}/\d{2}/\d{2,4}(?:\s*\d{2}:\d{2})?)%,
          :regex_capture_group => 1,
          :locale              => :default
        }
      end

      def regex
        @regex ||= Array(options[:regex])
      end

      def regex_capture_group
        @regex_capture_group ||= options[:regex_capture_group]
      end

      def locale
        @locale ||= options[:locale]
      end

      def match_any(string, regex)
        regex.map {|r| r.match(string) }.compact.first
      end
    end
  end
end
