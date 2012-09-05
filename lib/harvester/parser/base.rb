module Harvester
  class Parser
    class Base
      BLOCK_ELEMENTS = %W(br div p ul ol li form table pre tbody thead tr td th).freeze
      attr_reader :name, :options
      def initialize(name, options = {})
        @name    = name
        @options = default_options.merge(options)
      end

      def parse(node)
        {
          name => _parse(node)
        }
      end

      def _parse(node)
      end

      # When :after_parse hook is provided, calls it and uses its return value
      # Otherwise, returns whatever intermediate result was given
      def after_parse(node, intermediate_result)
        if after_hook
          after_hook.call(node, intermediate_result)
        else
          intermediate_result
        end
      end

      def selectors
        @selectors ||= Array(options[:selector] || options[:selectors])
      end

      def after_hook
        @after_hook ||= options[:after_parse]
      end

      def node_text(node)
        separator = BLOCK_ELEMENTS.include?(node.name) ? "\n" : ""
        if node.children.count > 0
          separator + node.children.map {|c| node_text(c) }.join("")
        else
          separator + node.text
        end
      end

      def default_options
        {}
      end
    end
  end
end
