require 'addressable/uri'
module Harvester
  class URLSlicer
    Result = Struct.new(:url, :uid)

    def self.call(*args)
      new.call(*args)
    end

    def call(url, keep_params = :all, keep_fragment = false)
      raise ArgumentError, "url param should be present for URLSlicer" unless url
      url = Addressable::URI.parse(url)
      url.fragment = nil unless keep_fragment
      keep_params = [keep_params] if keep_params.kind_of?(String)
      case keep_params
      when [], :all_without_query
        url.query = nil
        uid = url.to_s
      when Array
        url.query_values = slice_hash(url.query_values || {}, keep_params)
        uid = keep_params.sort.map {|key| url.query_values[key] }.compact.join("_")
        url.query_values = nil if url.query_values.empty?
      else
        uid = url.to_s
      end
      Result.new(url.to_s, uid)
    end

    def slice_hash(hash, *keep_keys)
      keep_keys = Array(keep_keys).flatten
      hash.dup.keep_if {|k,_| keep_keys.include?(k) }
    end
  end
end
