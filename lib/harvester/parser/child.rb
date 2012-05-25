module Harvester
  class Parser
    class Child < Children
      def parse(node)
        result = super
        result[name] = result[name].first
        result
      end
    end
  end
end
