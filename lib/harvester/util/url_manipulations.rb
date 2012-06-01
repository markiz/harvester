module Harvester
  module UrlManipulations
    extend self

    # Only keeps given params in url query
    #    url_with_sliced_params("forumdisplay.php?f=32&sid=afb213", ["f"])
    #    # => "forumdisplay.php?f=32"
    # If you pass :all as keep_params argument, returns url wholesale as uid
    #    url_with_sliced_params("x.php?id=23", :all)
    #    # => "x.php?id=23", "x.php?id=23"
    # If you pass :all_without_query, returns url with cut out query part
    #    url_with_sliced_params("x.php?id=23", :all_without_query)
    #    # => "x.php"
    def url_with_sliced_params(url, keep_params, keep_fragment = false)
      case keep_params
      when String
        url_with_sliced_params(url, [keep_params])
      when Array
        addressable = Addressable::URI.parse(url)
        addressable.query_values = slice_hash(addressable.query_values || {}, keep_params)
        addressable.fragment = nil unless keep_fragment
        addressable.to_s
      when :all
        url
      when :all_without_query
        url_without_query(url)
      else
        url
      end
    end

    def uid_from_sliced_params(url, keep_params)
      case keep_params
      when String
        uid_from_sliced_params(url, [keep_params])
      when Array
        addressable = Addressable::URI.parse(url)
        keep_params.sort.map {|key| addressable.query_values[key] }.compact.join("_")
      when :all
        url
      when :all_without_query
        url_without_query(url)
      else
        url
      end
    end

    def slice_hash(hash, *keep_keys)
      keep_keys = Array(keep_keys).flatten
      hash.dup.keep_if {|k,_| keep_keys.include?(k) }
    end

    def url_without_query(url)
      addressable = Addressable::URI.parse(url)
      addressable.query = nil
      addressable.to_s
    end
  end
end
