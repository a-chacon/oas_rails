module OasRails
  class OasRoute
    attr_accessor(:controller_class, :controller_action, :controller, :controller_path, :method, :verb, :path,
                  :rails_route, :docstring, :source_string)

    def initialize; end

    def self.new_from_rails_route(rails_route: ActionDispatch::Journey::Route)
      instance = new
      instance.rails_route = rails_route
      instance.extract_rails_route_data
      instance
    end

    def extract_rails_route_data
      @controller_action = "#{@rails_route.defaults[:controller].camelize}Controller##{@rails_route.defaults[:action]}"
      @controller_class = "#{@rails_route.defaults[:controller].camelize}Controller"
      @controller = @rails_route.defaults[:controller]
      @controller_path = controller_path_extractor(@rails_route.defaults[:controller])
      @method = @rails_route.defaults[:action]
      @verb = @rails_route.verb
      @path = Extractors::RouteExtractor.clean_route(@rails_route.path.spec.to_s)
      @docstring = extract_docstring
      @source_string = extract_source_string
    end

    def extract_docstring
      ::YARD::Docstring.parser.parse(
        controller_class.constantize.instance_method(method).comment.lines.map { |line| line.sub(/^#\s*/, '') }.join
      ).to_docstring
    end

    def extract_source_string
      @controller_class.constantize.instance_method(method).source
    end

    def path_params
      @rails_route.path.spec.to_s.scan(/:(\w+)/).flatten.reject! { |e| e == 'format' }
    end

    def controller_path_extractor(controller)
      Rails.root.join("app/controllers/#{controller}_controller.rb").to_s
    end

    def detect_request_body
      klass = @controller.singularize.camelize.constantize
      RequestBody.from_model_class(klass:, required: true)
    end
  end
end
