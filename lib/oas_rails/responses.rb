module OasRails
  class Responses < OasBase
    attr_accessor :responses

    def initialize(responses)
      super()
      @responses = responses
    end

    def to_spec
      @responses.each_with_object({}) { |r, object| object[r.code] = r.to_spec }
    end

    class << self
      def from_tags(tags:)
        new(tags.map { |t| Response.new(code: t.name.to_i, description: t.text, content: { "application/json": MediaType.new(schema: t.schema) }) })
      end
    end
  end
end
