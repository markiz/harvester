module Harvester
  class Parser
    class Children < Base
      def initialize(*args, &block)
        super
        @delegated_parser = Parser.new(&block)
      end

      def _parse(node)
        node.css(*selectors).map do |child_node|
          @delegated_parser.parse(child_node)
        end
      end
    end
  end
end
