module Harvester
  class Parser
    class Text < Base
      def _parse(node)
        after_parse(node, node_text(node).strip)
      end
    end
  end
end
