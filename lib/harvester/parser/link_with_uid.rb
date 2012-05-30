module Harvester
  class Parser
    class LinkWithUid < LinksWithUid
      def _parse(node)
        super.first
      end
    end
  end
end
