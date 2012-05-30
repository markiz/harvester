module Harvester
  class Parser
    class LinksWithUid < Links
      def _parse(node)
        links = LinkFinder.find_matching_links(node, selectors, link_regex)
        links.map do |link|
          url = link[:href]
          sliced_url = UrlManipulations.url_with_sliced_params(url, uid_keep_params)
          sliced_uid = UrlManipulations.uid_from_sliced_params(url, uid_keep_params)
          after_parse(link, {
            :url => sliced_url,
            :uid => sliced_uid
          })
        end
      end

      def default_options
        {
          :uid_keep_params => :all,
          :link_regex      => /.+/,
          :selectors       => "a"
        }
      end

      def uid_keep_params
        @uid_keep_params ||= options[:uid_keep_params]
      end
    end
  end
end
