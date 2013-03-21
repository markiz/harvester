module Harvester
  class Parser
    class Elements < Base
      def _parse(node)
        elements = node.search(*selectors)
        elements.map {|element| [element, node_text(element)] }.
            select {|element, text| positive_regex.any? {|r| r =~ text } }.
            reject {|element, text| negative_regex.any? {|r| r =~ text } }.
            map {|element, text| after_parse(element, text) }.
            compact.join(separator).strip
      end

      def separator
        options[:separator]
      end

      def positive_regex
        Array(options[:regex])
      end

      def negative_regex
        Array(options[:negative_regex])
      end

      def default_options
        {
          :selectors => "p",
          :separator => "",
          :regex     => /.*/,
          :negative_regex => []
        }
      end
    end
  end
end
