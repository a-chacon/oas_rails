module OasRails
  module Builders
    module EsquemaBuilder
      class << self
        # Builds a schema for a class when it is used as incoming API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_incoming_schema(klass:, model_to_schema_class: Esquema)
          configure_common_settings
          model_to_schema_class.configuration.excluded_columns = OasRails.config.excluded_columns_incoming

          model_to_schema_class::Builder.new(klass).build_schema.as_json
        end

        # Builds a schema for a class when it is used as outgoing API data.
        #
        # @param klass [Class] The class for which the schema is built.
        # @return [Hash] The schema as a JSON-compatible hash.
        def build_outgoing_schema(klass:, model_to_schema_class: Esquema)
          configure_common_settings
          model_to_schema_class.configuration.excluded_columns = OasRails.config.excluded_columns_outgoing

          model_to_schema_class::Builder.new(klass).build_schema.as_json
        end

        private

        # Configures common settings for schema building.
        #
        # Excludes associations and foreign keys from the schema.
        def configure_common_settings
          Esquema.configuration.exclude_associations = true
          Esquema.configuration.exclude_foreign_keys = true
        end
      end
    end
  end
end
