module OasRails
  module Spec
    class Paths
      include Specable

      attr_accessor :path_items

      def initialize(path_items:)
        @path_items = path_items
      end

      def self.from_string_paths(string_paths:)
        path_items = string_paths.each_with_object({}) do |s, object|
          object[s] = Spec::PathItem.from_oas_routes(oas_routes: Extractors::RouteExtractor.host_routes_by_path(s))
        end

        new(path_items:)
      end

      def to_spec
        paths_hash = {}
        @path_items.each do |path, path_object|
          paths_hash[path] = path_object.to_spec
        end
        paths_hash
      end
    end
  end
end
