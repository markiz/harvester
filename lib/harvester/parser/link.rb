require 'addressable/uri'

module Harvester
  class Parser
    class Link < Links
      def _parse(node)
        super.first
      end
    end
  end
end
