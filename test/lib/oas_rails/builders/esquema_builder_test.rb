module OasRails
  module Builders
    class EsquemaBuilderTest < Minitest::Test
      def setup
        @user_klass = User
        @invalid_klass = Object
        @custom_schema_class = EasyTalk
      end

      def test_build_incoming_schema
        schema = OasRails::Builders::EsquemaBuilder.build_incoming_schema(klass: @user_klass)

        assert_instance_of Hash, schema
        refute_includes schema["properties"].keys, "id"
      end

      def test_build_outgoing_schema
        schema = OasRails::Builders::EsquemaBuilder.build_outgoing_schema(klass: @user_klass)

        assert_instance_of Hash, schema
        assert_includes schema["properties"].keys, "id"
      end

      def test_build_incoming_schema_with_custom_schema_class
        schema = OasRails::Builders::EsquemaBuilder.build_incoming_schema(
          klass: @user_klass,
          model_to_schema_class: @custom_schema_class
        )

        assert_instance_of Hash, schema
        refute_includes schema["properties"].keys, "id"
      end

      def test_build_outgoing_schema_with_custom_schema_class
        schema = OasRails::Builders::EsquemaBuilder.build_outgoing_schema(
          klass: @user_klass,
          model_to_schema_class: @custom_schema_class
        )

        assert_instance_of Hash, schema
        assert_includes schema["properties"].keys, "id"
      end

      def test_build_schema_with_invalid_klass
        assert_raises(ArgumentError) do
          OasRails::Builders::EsquemaBuilder.build_incoming_schema(klass: @invalid_klass)
        end
      end
    end
  end
end
