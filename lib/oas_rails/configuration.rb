module OasRails
  class Configuration
    attr_accessor :info, :default_tags_from, :autodiscover_request_body, :autodiscover_responses
    attr_reader :servers, :tags

    def initialize(**kwargs)
      @info = Info.new
      @servers = kwargs[:servers] || default_servers
      @tags = []
      @swagger_version = '3.1.0'
      @default_tags_from = "namespace"
      @autodiscover_request_body = true
      @autodiscover_responses = true
    end

    def default_servers
      [Server.new(url: "http://localhost:3000", description: "Rails Default Development Server")]
    end

    def servers=(value)
      @servers = value.map { |s| Server.new(url: s[:url], description: s[:description]) }
    end

    def tags=(value)
      @tags = value.map { |t| Tag.new(name: t[:name], description: t[:description]) }
    end
  end
end
