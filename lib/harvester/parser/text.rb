module Harvester
  class Parser
    class Text < Base
      def _parse(node)
        after_parse(node, node.text)
      end
    end
  end
end
