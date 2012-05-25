module Harvester
  class Parser
    class Base
      attr_reader :name, :options
      def initialize(name, options = {})
        @name    = name
        @options = default_options.merge(options)
      end

      def parse(node)
        {}
      end

      protected

      def selectors
        @selectors ||= Array(@options[:selectors] || @options[:selector])
      end

      def default_options
        {}
      end
    end
  end
end
