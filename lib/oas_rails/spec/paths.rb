module OasRails
  module Spec
    class Paths
      include Specable

      attr_accessor :path_items

      def initialize(specification)
        @specification = specification
        @path_items = {}
      end

      def add_path(path)
        @path_items[path] = Builders::PathItemBuilder.new(@specification).from_path(path).build
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
