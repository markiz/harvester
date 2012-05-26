module Harvester
  class Parser
    class Element < Base
      def _parse(node)
        element = node.at_css(*selectors)
        element.text if element
      end
    end
  end
end
