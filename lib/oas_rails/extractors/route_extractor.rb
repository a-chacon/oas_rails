module OasRails
  module Extractors
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

        # Clear Class Instance Variable @host_routes
        #
        # This method clear the class instance variable @host_routes
        # to force a extraction of the routes again.
        def clear_cache
          @host_routes = nil
        end

        def host_paths
          @host_paths ||= host_routes.map(&:path).uniq.sort
        end

        def clean_route(route)
          route.gsub('(.:format)', '').gsub(/:\w+/) { |match| "{#{match[1..]}}" }
        end

        private

        def extract_host_routes
          routes = valid_routes.map { |r| Builders::OasRouteBuilder.build_from_rails_route(r) }

          routes.select! { |route| route.tags.any? } if OasRails.config.include_mode == :with_tags
          routes.select! { |route| route.tags.any? { |t| t.tag_name == "oas_include" } } if OasRails.config.include_mode == :explicit
          routes
        end

        def valid_routes
          all_routes = []

          # Add main application routes
          Rails.application.routes.routes.each do |route|
            all_routes << route if valid_api_route?(route)
          end

          # Add engine routes
          collect_engine_routes.each do |engine_route_info|
            route = engine_route_info[:route]
            full_path = engine_route_info[:full_path]

            # For engine routes we need to check against the full path (with mount prefix)
            if valid_engine_api_route?(route, full_path)
              # Create a route wrapper that provides the correct path
              all_routes << EngineRouteWrapper.new(route, full_path)
            end
          end

          all_routes
        end

        # Collect all routes from mounted engines with their full paths
        def collect_engine_routes
          engine_routes = []

          Rails.application.routes.routes.each do |route|
            # Check if this route is a mounted engine
            next unless route.app.is_a?(Class) && route.app.ancestors.include?(Rails::Engine)

            # Get the engine instance and its mount path
            engine = route.app.instance
            engine_mount_path = route.path.spec.to_s.chomp('/')

            # Add all routes from this engine with their full paths
            engine.routes.routes.each do |engine_route|
              full_path = File.join(engine_mount_path, engine_route.path.spec.to_s).gsub(%r{/+}, '/')
              engine_routes << { route: engine_route, full_path: full_path }
            end
          end

          engine_routes
        end

        # Check if an engine route should be included
        def valid_engine_api_route?(route, full_path)
          return false unless valid_route_implementation?(route)
          return false if RAILS_DEFAULT_CONTROLLERS.any? { |default| route.defaults[:controller].start_with?(default) }
          return false if RAILS_DEFAULT_PATHS.any? { |path| full_path.include?(path) }
          return false unless full_path.start_with?(OasRails.config.api_path)
          return false if ignore_custom_actions(route)

          true
        end

        def valid_api_route?(route)
          return false unless valid_route_implementation?(route)
          return false if RAILS_DEFAULT_CONTROLLERS.any? { |default| route.defaults[:controller].start_with?(default) }
          return false if RAILS_DEFAULT_PATHS.any? { |path| route.path.spec.to_s.include?(path) }
          return false unless route.path.spec.to_s.start_with?(OasRails.config.api_path)
          return false if ignore_custom_actions(route)

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
            controller_class.instance_methods.include?(action_name.to_sym)
          end
        end

        # Ignore user-specified paths in initializer configuration.
        # Sanitize api_path by removing the "/" if it starts with that, and adding "/" if it ends without that.
        # Support controller name only to ignore all controller actions.
        # Support ignoring "controller#action"
        # Ignoring "controller#action" AND "api_path/controller#action"
        def ignore_custom_actions(route)
          api_path = "#{OasRails.config.api_path.sub(%r{\A/}, '')}/".sub(%r{/+$}, '/')
          ignored_actions = OasRails.config.ignored_actions.flat_map do |custom_route|
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
