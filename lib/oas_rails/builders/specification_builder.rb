module OasRails
  module Builders
    class SpecificationBuilder
      def initialize(route_extractor)
        @specification = Spec::Specification.new
        @specification.route_extractor = route_extractor
      end

      def fill_paths
        @specification.route_extractor.host_paths.each do |path|
          @specification.paths.add_path(path)
        end

        self
      end

      def build
        @specification
      end
    end
  end
end
