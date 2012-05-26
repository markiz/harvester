module Harvester
  class Parser
    class Child < Children
      def _parse(*args)
        super.first
      end
    end
  end
end
