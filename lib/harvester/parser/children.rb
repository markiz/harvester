module Harvester
  class Parser
    class Children < Base
      attr_reader :delegate

      def initialize(name, options = {}, &block)
        super
        @delegate = Parser.new(&block)
      end

      def parse(node)
        parsed_children = node.css(*selectors).inject([]) do |result, parsed_node|
          result << @delegate.parse(parsed_node)
        end
        {
          name => parsed_children
        }
      end
    end
  end
end
