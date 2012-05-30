module Harvester
  class Parser
    class LinkWithUid < Link
      def parse(node)
        link = LinkFinder.find_matching_link(node, selectors, link_regex)
        if link
          url = link[:href]
          sliced_url = UrlManipulations.url_with_sliced_params(url, uid_keep_params)
          sliced_uid = UrlManipulations.uid_from_sliced_params(url, uid_keep_params)
          after_parse(link, {
            url_key => sliced_url,
            uid_key => sliced_uid
          })
        end
      end

      def default_options
        {
          :uid_keep_params => :all,
          :url_key         => :"#{name}_url",
          :uid_key         => :"#{name}_uid",
          :link_regex      => /.+/,
          :selectors       => "a"
        }
      end

      def uid_keep_params
        @uid_keep_params ||= options[:uid_keep_params]
      end

      def url_key
        @url_key ||= options[:url_key]
      end

      def uid_key
        @uid_key ||= options[:uid_key]
      end
    end
  end
end
