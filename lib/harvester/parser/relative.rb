module Harvester
  class Parser
    class Relative < Base
      def initialize(options = {}, &block)
        super(nil, options)
        @delegated_parser = Parser.new(&block)
      end

      def parse(node)
        next_relative = next_matching_relative(node)
        if next_relative
          @delegated_parser.parse(next_relative)
        else
          {}
        end
      end

      def next_matching_relative(node)
        if selectors.empty?
          next_checked_node(node)
        else
          n = next_checked_node(node)
          while n && !selectors.any? {|selector| n.matches?(selector) }
            n = next_checked_node(n)
          end
          n
        end
      end

      def next_checked_node(node)
      end
    end
  end
end
