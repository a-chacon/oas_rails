module OasRails
  module Web
    class View
      def self.call(env)
        new.call(env)
      end

      def call(env)
        request = Rack::Request.new(env)
        oas = OasRails.build.to_json

        if request.path.end_with?('.json')
          [200, { "Content-Type" => "application/json" }, [oas]]
        elsif request.path.end_with?('.js')
          [200, { "Content-Type" => "application/javascript" }, [render_js]]
        else
          [200, { "Content-Type" => "text/html" }, [render_view]]
        end
      end

      def render_view
        template_path = File.expand_path("views/index.html.erb", __dir__)
        template = File.read(template_path)
        ERB.new(template).result(binding)
      end

      def render_js
        template_path = File.expand_path("assets/rapidoc-min.js", __dir__)
        File.read(template_path)
      end
    end
  end
end
