module OasRails
  class Server < OasBase
    attr_accessor :url, :description

    def initialize(url:, description:)
      @url = url
      @description = description
    end
  end
end
