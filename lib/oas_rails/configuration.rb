module OasRails
  class Configuration
    attr_accessor :info,
                  :default_tags_from,
                  :autodiscover_request_body,
                  :autodiscover_responses,
                  :api_path,
                  :security_schemas,
                  :authenticate_all_routes_by_default,
                  :set_default_responses,
                  :possible_default_responses,
                  :response_body_of_default
    attr_reader :servers, :tags, :security_schema

    def initialize
      @info = Spec::Info.new
      @servers = default_servers
      @tags = []
      @swagger_version = '3.1.0'
      @default_tags_from = "namespace"
      @autodiscover_request_body = true
      @autodiscover_responses = true
      @api_path = "/"
      @authenticate_all_routes_by_default = true
      @security_schema = nil
      @security_schemas = {}
      @set_default_responses = true
      @possible_default_responses = [:not_found, :unauthorized, :forbidden]
      @response_body_of_default = { message: String }
    end

    def security_schema=(value)
      return unless (security_schema = DEFAULT_SECURITY_SCHEMES[value])

      @security_schemas = { value => security_schema }
    end

    def default_servers
      [Spec::Server.new(url: "http://localhost:3000", description: "Rails Default Development Server")]
    end

    def servers=(value)
      @servers = value.map { |s| Spec::Server.new(url: s[:url], description: s[:description]) }
    end

    def tags=(value)
      @tags = value.map { |t| Spec::Tag.new(name: t[:name], description: t[:description]) }
    end

    def excluded_columns_incoming
      %i[id created_at updated_at deleted_at]
    end

    def excluded_columns_outgoing
      []
    end
  end

  DEFAULT_SECURITY_SCHEMES = {
    api_key_cookie: {
      type: "apiKey",
      in: "cookie",
      name: "api_key",
      description: "An API key that will be supplied in a named cookie."
    },
    api_key_header: {
      type: "apiKey",
      in: "header",
      name: "X-API-Key",
      description: "An API key that will be supplied in a named header."
    },
    api_key_query: {
      type: "apiKey",
      in: "query",
      name: "apiKey",
      description: "An API key that will be supplied in a named query parameter."
    },
    basic: {
      type: "http",
      scheme: "basic",
      description: "Basic auth that takes a base64'd combination of `user:password`."
    },
    bearer: {
      type: "http",
      scheme: "bearer",
      description: "A bearer token that will be supplied within an `Authorization` header as `bearer <token>`."
    },
    bearer_jwt: {
      type: "http",
      scheme: "bearer",
      bearerFormat: "JWT",
      description: "A bearer token that will be supplied within an `Authorization` header as `bearer <token>`. In this case, the format of the token is specified as JWT."
    },
    mutual_tls: {
      type: "mutualTLS",
      description: "Requires a specific mutual TLS certificate to use when making an HTTP request."
    }
  }.freeze
end
