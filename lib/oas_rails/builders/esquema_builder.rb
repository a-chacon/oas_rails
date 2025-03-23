module OasRails
  module Builders
    module EsquemaBuilder
      class << self
        # Builds a schema for a class when it is used as incoming API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_incoming_schema(klass:, model_to_schema_class: EasyTalk)
          configure_common_settings(model_to_schema_class:)
          model_to_schema_class.configuration.excluded_columns = OasRails.config.excluded_columns_incoming

          model_to_schema_class::ActiveRecordSchemaBuilder.new(klass).build_schema_definition.as_json["schema"]
        end

        # Builds a schema for a class when it is used as outgoing API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_outgoing_schema(klass:, model_to_schema_class: EasyTalk)
          configure_common_settings(model_to_schema_class:)
          model_to_schema_class.configuration.excluded_columns = OasRails.config.excluded_columns_outgoing
          model_to_schema_class.configuration.exclude_primary_key = false

          model_to_schema_class::ActiveRecordSchemaBuilder.new(klass).build_schema_definition.as_json["schema"]
        end

        private

        # Configures common settings for schema building.
        #
        # Excludes associations and foreign keys from the schema.
        def configure_common_settings(model_to_schema_class: EasyTalk)
          model_to_schema_class.configuration.exclude_associations = true
          model_to_schema_class.configuration.exclude_foreign_keys = true
        end
      end
    end
  end
end
