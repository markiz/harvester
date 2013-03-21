module Harvester
  class Parser
    class LinksWithUid < Links
      def _parse(node)
        links = link_finder.call(node).map {|link|
          sliced_url = URLSlicer.call(link[:href].strip, uid_keep_params, keep_fragment)
          after_parse(link, {
            :url => sliced_url.url,
            :uid => sliced_url.uid
          })
        }.compact.uniq
      end

      def link_finder
        @link_finder ||= LinkFinder.new(selectors, link_regex, LinkValidator.new(schemes))
      end

      def default_options
        {
          :uid_keep_params => :all,
          :link_regex      => /.+/,
          :selectors       => "a",
          :keep_fragment   => false,
          :schemes         => ["http", "https"]
        }
      end

      def uid_keep_params
        @uid_keep_params ||= options[:uid_keep_params]
      end

      def keep_fragment
        options[:keep_fragment]
      end

      def schemes
        options[:schemes]
      end
    end
  end
end
