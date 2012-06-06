module Harvester
  class Parser
    class Element < Base
      def _parse(node)
        element = node.search(*selectors).first
        after_parse(element, element.text.strip) if element
      end
    end
  end
end
