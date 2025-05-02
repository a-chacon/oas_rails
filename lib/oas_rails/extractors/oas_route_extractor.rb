module OasRails
  module Extractors
    module OasRouteExtractor
      def extract_summary(oas_route:)
        oas_route.tags(:summary).first.try(:text) || generate_crud_name(oas_route.method, oas_route.controller.downcase) || "#{oas_route.verb} #{oas_route.path}"
      end

      def extract_operation_id(oas_route:)
        "#{oas_route.method}#{oas_route.path.gsub('/', '_').gsub(/[{}]/, '')}"
      end

      def extract_tags(oas_route:)
        tags = oas_route.tags(:tags).first
        if tags.nil?
          default_tags(oas_route:)
        else
          tags.text.split(",").map(&:strip).map(&:titleize)
        end
      end

      def default_tags(oas_route:)
        tags = []
        if OasRails.config.default_tags_from == :namespace
          tag = oas_route.path.split('/').reject(&:empty?).first.try(:titleize)
          tags << tag unless tag.nil?
        else
          tags << oas_route.controller.gsub("/", " ").titleize
        end
        tags
      end

      def extract_security(oas_route:)
        return [] if oas_route.tags(:no_auth).any?

        if (methods = oas_route.tags(:auth).first)
          OasRails.config.security_schemas.keys.map { |key| { key => [] } }.select do |schema|
            methods.types.include?(schema.keys.first.to_s)
          end
        elsif OasRails.config.authenticate_all_routes_by_default
          OasRails.config.security_schemas.keys.map { |key| { key => [] } }
        else
          []
        end
      end

      private

      def generate_crud_name(method, controller)
        controller_name = controller.to_s.underscore.humanize.downcase.pluralize

        case method.to_sym
        when :index
          "List #{controller_name}"
        when :show
          "View #{controller_name.singularize}"
        when :create
          "Create new #{controller_name.singularize}"
        when :update
          "Update #{controller_name.singularize}"
        when :destroy
          "Delete #{controller_name.singularize}"
        end
      end
    end
  end
end
