module OasRails
  class PathItem
    attr_reader :path, :operations, :parameters

    def initialize(path:, operations:, parameters:)
      @path = path
      @operations = operations
      @parameters = parameters
    end

    def self.from_oas_routes(path:, oas_routes:)
      new(path: path, operations: oas_routes.map do |oas_route|
                                    Operation.from_oas_route(oas_route: oas_route)
                                  end, parameters: [])
    end

    def to_spec
      spec = {}
      @operations.each do |o|
        spec[o.method] = o.to_spec
      end
      spec
    end
  end
end
