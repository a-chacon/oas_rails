module OasRails
  class Configuration < OasCore::Configuration
    attr_reader :route_extractor

    def initialize
      super
      @route_extractor = Extractors::RouteExtractor
    end

    def route_extractor=(value)
      unless value.respond_to?(:host_routes) &&
             value.respond_to?(:host_routes_by_path) &&
             value.respond_to?(:clear_cache) &&
             value.respond_to?(:host_paths) &&
             value.respond_to?(:clean_route)
        raise ArgumentError,
              "Route extractor must have the following methods: host_routes, host_routes_by_path, clear_cache, host_paths, and clean_route"
      end

      @route_extractor = value
    end
  end
end
