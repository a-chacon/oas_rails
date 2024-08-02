module OasRails
  class Paths
    attr_accessor :path_items

    def initialize(path_items:)
      @path_items = path_items
    end

    def self.from_string_paths(string_paths:)
      new(path_items: string_paths.map do |s|
                        PathItem.from_oas_routes(path: s, oas_routes: Extractors::RouteExtractor.host_routes_by_path(s))
                      end)
    end

    def to_spec
      @path_items.each_with_object({}) { |p, object| object[p.path] = p.to_spec }
    end
  end
end
