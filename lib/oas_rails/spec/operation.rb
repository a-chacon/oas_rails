module OasRails
  module Spec
    class Operation
      include Specable

      attr_accessor :specification, :tags, :summary, :description, :operation_id, :parameters, :request_body, :responses, :security

      def initialize(specification)
        @specification = specification
        @summary = ""
        @operation_id = ""
        @tags = []
        @description = @summary
        @parameters = []
        @request_body = {}
        @responses =  Spec::Responses.new(specification)
        @security = []
      end

      def oas_fields
        [:tags, :summary, :description, :operation_id, :parameters, :request_body, :responses, :security]
      end
    end
  end
end
