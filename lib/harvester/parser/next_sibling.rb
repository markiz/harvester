module Harvester
  class Parser
    class NextSibling < Relative
      def next_checked_node(node)
        node.next_element
      end
    end
  end
end
