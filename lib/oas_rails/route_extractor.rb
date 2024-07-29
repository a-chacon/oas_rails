module OasRails
  class RouteExtractor
    RAILS_DEFAULT_CONTROLLERS = %w[
      rails/info
      rails/mailers
      active_storage/blobs
      active_storage/disk
      active_storage/direct_uploads
      active_storage/representations
      rails/conductor/continuous_integration
      rails/conductor/multiple_databases
      rails/conductor/action_mailbox
      rails/conductor/action_text
      action_cable
    ].freeze

    RAILS_DEFAULT_PATHS = %w[
      /rails/action_mailbox/
    ].freeze

    class << self
      def host_routes_by_path(path)
        @host_routes ||= extract_host_routes
        @host_routes.select { |r| r.path == path }
      end

      def host_routes
        @host_routes ||= extract_host_routes
      end

      def host_paths
        @host_paths ||= host_routes.map(&:path).uniq.sort
      end

      def clean_route(route)
        route.gsub('(.:format)', '').gsub(/:\w+/) { |match| "{#{match[1..]}}" }
      end

      # THIS CODE IS NOT IN USE BUT CAN BE USEFULL WITH GLOBAL TAGS OR AUTH TAGS
      # def get_controller_comments(controller_path)
      #   YARD.parse_string(File.read(controller_path))
      #   controller_class = YARD::Registry.all(:class).first
      #   if controller_class
      #     class_comment = controller_class.docstring.all
      #     method_comments = controller_class.meths.map do |method|
      #       {
      #         name: method.name,
      #         comment: method.docstring.all
      #       }
      #     end
      #     YARD::Registry.clear
      #     {
      #       class_comment: class_comment,
      #       method_comments: method_comments
      #     }
      #   else
      #     YARD::Registry.clear
      #     nil
      #   end
      # rescue StandardError
      #   nil
      # end
      #
      # def get_controller_comment(controller_path)
      #   get_controller_comments(controller_path)&.dig(:class_comment) || ''
      # rescue StandardError
      #   ''
      # end

      private

      def extract_host_routes
        Rails.application.routes.routes.select do |route|
          valid_api_route?(route)
        end.map { |r| OasRoute.new_from_rails_route(rails_route: r) }
      end

      def valid_api_route?(route)
        return false if route.defaults[:controller].nil?
        return false if RAILS_DEFAULT_CONTROLLERS.any? { |default| route.defaults[:controller].start_with?(default) }
        return false if RAILS_DEFAULT_PATHS.any? { |path| route.path.spec.to_s.include?(path) }
        return false unless route.path.spec.to_s.start_with?(OasRails.config.api_path)

        true
      end
    end
  end
end
