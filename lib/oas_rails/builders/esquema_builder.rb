module OasRails
  module Builders
    module EsquemaBuilder
      class << self
        # Builds a schema for a class when it is used as incoming API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_incoming_schema(klass:, model_to_schema_class: EasyTalk)
          build_schema(
            klass: klass,
            model_to_schema_class: model_to_schema_class,
            excluded_columns: OasRails.config.excluded_columns_incoming,
            exclude_primary_key: true
          )
        end

        # Builds a schema for a class when it is used as outgoing API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_outgoing_schema(klass:, model_to_schema_class: EasyTalk)
          build_schema(
            klass: klass,
            model_to_schema_class: model_to_schema_class,
            excluded_columns: OasRails.config.excluded_columns_outgoing,
            exclude_primary_key: false
          )
        end

        private

        # Builds a schema with the given configuration.
        #
        # @param klass [Class] The class for which the schema is built.
        # @param model_to_schema_class [Class] The schema builder class.
        # @param excluded_columns [Array] Columns to exclude from the schema.
        # @param exclude_primary_key [Boolean] Whether to exclude the primary key.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_schema(klass:, model_to_schema_class:, excluded_columns:, exclude_primary_key:)
          configure_common_settings(model_to_schema_class: model_to_schema_class)
          model_to_schema_class.configuration.excluded_columns = excluded_columns
          model_to_schema_class.configuration.exclude_primary_key = exclude_primary_key

          definition = model_to_schema_class::ActiveRecordSchemaBuilder.new(klass).build_schema_definition
          EasyTalk::Builders::ObjectBuilder.new(definition).build.as_json
        end

        # Configures common settings for schema building.
        #
        # Excludes associations and foreign keys from the schema.
        def configure_common_settings(model_to_schema_class: EasyTalk)
          model_to_schema_class.configuration.exclude_associations = true
        end
      end
    end
  end
end
