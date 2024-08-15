module OasRails
  module Builders
    class EsquemaBuilderTest < Minitest::Test
      def test_build_incoming_schema
        schema = OasRails::Builders::EsquemaBuilder.build_incoming_schema(klass: User)

        assert_instance_of Hash, schema
        refute_includes schema["properties"].keys, "id"
      end

      def test_build_outgoing_schema
        schema = OasRails::Builders::EsquemaBuilder.build_outgoing_schema(klass: User)

        assert_instance_of Hash, schema
        assert_includes schema["properties"].keys, "id"
      end
    end
  end
end
