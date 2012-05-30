module Harvester
  class Parser
    class LinkWithUid < Link
      def parse(node)
        link = find_matching_link(node)
        if link
          url = link[:href]
          sliced_url = url_with_sliced_params(url, uid_keep_params)
          sliced_uid = sliced_params(url, uid_keep_params).join("_")
          after_parse(link, {
            url_key => sliced_url,
            uid_key => sliced_uid
          })
        end
      end

      # Only keeps given params in url query
      #    url_with_sliced_params("forumdisplay.php?f=32&sid=afb213", ["f"])
      #    # => "forumdisplay.php?f=32"
      # If you pass :all as keep_params argument, returns url wholesale as uid
      #    url_with_sliced_params("x.php?id=23", :all)
      #    # => "x.php?id=23", "x.php?id=23"
      # If you pass :all_without_query, returns url with cut out query part
      #    url_with_sliced_params("x.php?id=23", :all_without_query)
      #    # => "x.php"
      def url_with_sliced_params(url, keep_params)
        case keep_params
        when String
          url_with_sliced_params(url, [keep_params])
        when Array
          addressable = Addressable::URI.parse(url)
          addressable.query_values = slice_hash(addressable.query_values || {}, keep_params)
          addressable.to_s
        else
          [url, nil]
        end
      end

      def sliced_params(url, keep_params)
        case keep_params
        when String
          sliced_params(url, [keep_params])
        when Array
          addressable = Addressable::URI.parse(url)
          keep_params.sort.map {|key| addressable.query_values[key] }.compact
        else
          [url]
        end
      end

      def slice_hash(hash, *keep_keys)
        keep_keys = Array(keep_keys).flatten
        hash.dup.keep_if {|k,_| keep_keys.include?(k) }
      end

      def uid_keep_params
        @uid_keep_params ||= options[:uid_keep_params] || :all
      end

      def url_key
        @url_key ||= options[:url_key] || :"#{name}_url"
      end

      def uid_key
        @uid_key ||= options[:uid_key] || :"#{name}_uid"
      end
    end
  end
end
