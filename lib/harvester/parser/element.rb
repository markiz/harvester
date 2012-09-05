module Harvester
  class Parser
    class Element < Base
      def _parse(node)
        element = node.search(*selectors).first
        after_parse(element, node_text(element).strip) if element
      end
    end
  end
end
