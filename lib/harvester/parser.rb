require 'nokogiri'
require 'harvester/parser/base'
require 'harvester/parser/element'
require 'harvester/parser/text'
require 'harvester/parser/children'
require 'harvester/parser/child'
require 'harvester/parser/link'
require 'harvester/parser/link_with_uid'

module Harvester
  class Parser
    def initialize(&block)
      block.call(self) if block_given?
    end

    def parser_nodes
      @parser_nodes ||= []
    end

    def parse(doc_or_node)
      node = node_from_doc_or_node(doc_or_node)
      parser_nodes.inject({}) do |result, parser_node|
        result.merge(parser_node.parse(node))
      end
    end

    PARSER_NODES_MAP = {
      :element  => Element,
      :children => Children,
      :child    => Child,
      :link     => Link,
      :text     => Text
    }.freeze

    PARSER_NODES_MAP.each do |node_type, node_class|
      class_eval <<-EOF
      def #{node_type}(*args, &block)
        parser_nodes << #{node_class}.new(*args, &block)
      end
      EOF
    end

    protected

    def node_from_doc_or_node(doc_or_node)
      case doc_or_node
      when String
        Nokogiri::HTML(doc_or_node)
      else
        doc_or_node
      end
    end
  end
end
