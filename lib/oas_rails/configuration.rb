module OasRails
  class Configuration < OasCore::Configuration
    attr_accessor :autodiscover_request_body, :autodiscover_responses, :ignored_actions, :rapidoc_theme, :layout, :source_oas_path, :rapidoc_configuration, :rapidoc_logo_url
    attr_reader :route_extractor, :include_mode

    def initialize
      super
      @route_extractor = Extractors::RouteExtractor
      @include_mode = :all
      @autodiscover_request_body = true
      @autodiscover_responses = true
      @ignored_actions = []
      @layout = nil
      @rapidoc_theme = :rails
      @rapidoc_configuration = {}
      @rapidoc_logo_url = nil
      @source_oas_path = nil

      # TODO: implement
      # autodiscover_request_body
      # autodiscover_responses
    end

    def excluded_columns_incoming
      %i[id created_at updated_at deleted_at]
    end

    def excluded_columns_outgoing
      []
    end

    def include_mode=(value)
      valid_modes = %i[all with_tags explicit]
      raise ArgumentError, "include_mode must be one of #{valid_modes}" unless valid_modes.include?(value)

      @include_mode = value
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
