module Harvester
  class Parser
    class Date < Base
      def _parse(node)
        node.search(*selectors).map do |checked_node|
          if (match = match_any(checked_node.text, regex))
            time_string = prepare_time_string(match[regex_capture_group])
            DateParser.parse(time_string, locale)
          end
        end.compact.first
      end

      def default_options
        {
          :before_parse        => nil,
          :regex               => %r%(\d{2}/\d{2}/\d{2,4}(?:\s*\d{2}:\d{2})?)%,
          :regex_capture_group => 1,
          :locale              => :default
        }
      end

      def prepare_time_string(time_string)
        if options[:before_parse]
          options[:before_parse].call(time_string)
        else
          time_string
        end
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
