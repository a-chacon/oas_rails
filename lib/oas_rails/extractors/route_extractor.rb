module OasRails
  module Extractors
    class RouteExtractor
      RAILS_DEFAULT_CONTROLLERS = %w[
        rails
        action_mailbox
        action_cable
        active_storage
        turbo/native
      ].freeze

      class << self
        def host_routes_by_path(path, config:)
          @host_routes_cache ||= {}
          @host_routes_cache[config.name] ||= extract_host_routes(config:)
          @host_routes_cache[config.name].select { |r| r.path == path }
        end

        def host_routes(config:)
          @host_routes_cache ||= {}
          @host_routes_cache[config.name] ||= extract_host_routes(config:)
        end

        # Clear the cached routes.
        #
        # When a +config+ is given, only that config's cache entry is cleared,
        # forcing the next call to re-extract routes for that configuration.
        # When called without arguments, the entire cache is cleared for all
        # configurations.
        def clear_cache(config: nil)
          if config
            @host_routes_cache&.delete(config.name)
            @host_paths_cache&.delete(config.name)
          else
            @host_routes_cache = nil
            @host_paths_cache = nil
          end
        end

        def host_paths(config:)
          @host_paths_cache ||= {}
          @host_paths_cache[config.name] ||= host_routes(config:).map(&:path).uniq.sort
        end

        def clean_route(route)
          route.gsub('(.:format)', '').gsub(/:\w+/) { |match| "{#{match[1..]}}" }
        end

        private

        def extract_host_routes(config:)
          routes = valid_routes(config:).map { |r| Builders::OasRouteBuilder.build_from_rails_route(r, config:) }

          routes.select! { |route| route.tags.any? } if config.include_mode == :with_tags
          routes.select! { |route| route.tags.any? { |t| t.tag_name == "oas_include" } } if config.include_mode == :explicit
          routes
        end

        def valid_routes(config:)
          Rails.application.routes.routes.select do |route|
            valid_api_route?(route, config:)
          end
        end

        def valid_api_route?(route, config:)
          return false unless valid_route_implementation?(route)
          return false if RAILS_DEFAULT_CONTROLLERS.any? { |default| route.defaults[:controller].start_with?(default) }
          return false unless route.path.spec.to_s.start_with?(config.api_path)
          return false if ignore_custom_actions?(route, config:)

          true
        end

        # Checks if a route has a valid implementation.
        #
        # This method verifies that both the controller and the action specified
        # in the route exist. It checks if the controller class is defined and
        # if the action method is implemented within that controller.
        #
        # @param route [ActionDispatch::Journey::Route] The route to check.
        # @return [Boolean] true if both the controller and action exist, false otherwise.
        def valid_route_implementation?(route)
          controller_name = route.defaults[:controller]&.camelize
          action_name = route.defaults[:action]

          return false if controller_name.blank? || action_name.blank?

          controller_class = "#{controller_name}Controller".safe_constantize

          if controller_class.nil?
            false
          else
            controller_class.method_defined?(action_name.to_sym)
          end
        end

        # Ignore user-specified paths in initializer configuration.
        # Sanitize api_path by removing the "/" if it starts with that, and adding "/" if it ends without that.
        # Support controller name only to ignore all controller actions.
        # Support ignoring "controller#action"
        # Ignoring "controller#action" AND "api_path/controller#action"
        def ignore_custom_actions?(route, config:)
          api_path = "#{config.api_path.sub(%r{\A/}, '')}/".sub(%r{/+$}, '/')
          ignored_actions = config.ignored_actions.flat_map do |custom_route|
            if custom_route.start_with?(api_path)
              [custom_route]
            else
              ["#{api_path}#{custom_route}", custom_route]
            end
          end

          controller_action = "#{route.defaults[:controller]}##{route.defaults[:action]}"
          controller_only = route.defaults[:controller]

          ignored_actions.include?(controller_action) || ignored_actions.include?(controller_only)
        end
      end
    end
  end
end
