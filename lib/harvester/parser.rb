require 'nokogiri'
require 'harvester/parser/base'
require 'harvester/parser/element'
require 'harvester/parser/children'
require 'harvester/parser/child'
require 'harvester/parser/link'

module Harvester
  class Parser
    def initialize(&block)
      block.call(self)
    end

    def parser_nodes
      @parser_nodes ||= []
    end

    def parse(node_or_html)
      node = case node_or_html
      when String
        Nokogiri::HTML(node_or_html)
      else
        node_or_html
      end

      parser_nodes.inject({}) do |result, parser_node|
        result.merge!(parser_node.parse(node))
      end
    end

    def link(*args, &block)
      parser_nodes << Link.new(*args, &block)
    end

    def element(*args, &block)
      parser_nodes << Element.new(*args, &block)
    end

    def child(*args, &block)
      parser_nodes << Child.new(*args, &block)
    end

    def children(*args, &block)
      parser_nodes << Children.new(*args, &block)
    end
  end
end
