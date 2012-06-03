module Harvester
  class Parser
    class PrevSibling < Relative
      def next_checked_node(node)
        node.previous_element
      end
    end
  end
end
