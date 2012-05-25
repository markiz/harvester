module Harvester
  class Parser
    class Element < Base
      def parse(node)
        {
          name => node.at_css(*selectors).text
        }
      end
    end
  end
end
