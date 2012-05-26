module Harvester
  class Parser
    class Base
      attr_reader :name, :options
      def initialize(name, options = {})
        @name    = name
        @options = default_options.merge(options)
      end

      def parse(node)
        {
          name => _parse(node)
        }
      end

      def _parse(node)
      end

      def selectors
        @selectors ||= Array(options[:selector] || options[:selectors])
      end

      def default_options
        {}
      end
    end
  end
end
