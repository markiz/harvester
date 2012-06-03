module Harvester
  class Parser
    class Parent < Relative
      def next_checked_node(node)
        node.respond_to?(:parent) && node.parent
      end
    end
  end
end
