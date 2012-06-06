module Harvester
  class Parser
    class Text < Base
      def _parse(node)
        after_parse(node, node.text.strip)
      end
    end
  end
end
