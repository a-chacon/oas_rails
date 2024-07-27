module OasRails
  class Response < OasBase
    attr_accessor :code, :description, :content

    def initialize(code:, description:, content:)
      super()
      @code = code
      @description = description
      @content = content # Should be an array of media type object
    end
  end
end
