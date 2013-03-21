module Harvester
  class LinkFinder
    attr_reader :selectors, :link_regex, :validator
    def initialize(selectors, link_regex, validator)
      @selectors  = selectors
      @link_regex = link_regex
      @validator  = validator
    end

    def call(node)
      node.search(*selectors).
          select {|link| link[:href] &&
                         validator.call(link[:href]) &&
                         match_any?(link[:href], link_regex) }
    end
    alias_method :find_matching_links, :call

    def match_any?(string, regex)
      regex.any? {|r| r =~ string }
    end
  end
end
