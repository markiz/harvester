module Util
  # Extracts text from an xml node, separating block elements with newlines
  #
  # @example
  #    TextExtractor.call(Nokogiri::HTML.fragment('Some text<p>Hello, world<p>Second paragraph'))
  #    # => "Some text\nHello, world\nSecond paragraph"
  class TextExtractor
    BLOCK_ELEMENTS = %W(br div p ul ol li form table pre tbody thead tr td th).freeze

    def self.call(node)
      separator = BLOCK_ELEMENTS.include?(node.name) ? "\n" : ''
      case
      when node.name == 'script'
        ''
      when node.comment?
        ''
      when node.children.count > 0
        separator + node.children.map {|c| call(c) }.join('')
      else
        separator + node.text
      end
    end
  end
end
