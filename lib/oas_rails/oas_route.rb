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
      @path = RouteExtractor.clean_route(@rails_route.path.spec.to_s)
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

    def extract_responses_from_source
      render_calls = @source_string.scan(/render json: ((?:\{.*?\}|\S+))(?:, status: :(\w+))?(?:,.*?)?$/m)

      return [Response.new(code: 204, description: "No Content", content: {})] if render_calls.empty?

      render_calls.map do |render_content, status|
        content = render_content.strip

        # TODO: manage when is an array of errors
        schema = {}
        begin
          schema = if content.start_with?('{')
                     Utils.hash_to_json_schema(parse_hash_structure(content))
                   else
                     # It's likely a variable or method call
                     maybe_a_model, errors = content.gsub('@', "").split(".")
                     klass = maybe_a_model.singularize.camelize(:upper).constantize
                     return {} unless klass.ancestors.include? ActiveRecord::Base

                     e = Esquema::Builder.new(klass).build_schema.as_json
                     if test_singularity(maybe_a_model)
                       if errors.nil?
                         e
                       else
                         {
                           type: "object",
                           properties: {
                             success: {
                               type: "boolean"
                             },
                             errors: {
                               type: "object",
                               additionalProperties: {
                                 type: "array",
                                 items: {
                                   type: "string"
                                 }
                               }
                             }
                           }
                         } end
                     else
                       { type: "array", items: e }
                     end
                   end
        rescue StandardError => e
          Rails.logger.debug("Error building schema: #{e.message}")
        end

        status_int = status_to_integer(status)
        Response.new(code: status_int, description: status_code_to_text(status_int), content: { "application/json": MediaType.new(schema:) })
      end
    end

    def test_singularity(str)
      str.pluralize != str && str.singularize == str
    end

    def parse_hash_structure(hash_literal)
      structure = {}

      hash_literal.scan(/(\w+):\s*(\S+)/) do |key, value|
        structure[key.to_sym] = case value
                                when 'true', 'false'
                                  'Boolean'
                                when /^\d+$/
                                  'Number'
                                when '@user.errors'
                                  'Object'
                                else
                                  'Object'
                                end
      end

      structure
    end

    def status_to_integer(status)
      return 200 if status.nil?

      if status.to_s =~ /^\d+$/
        status.to_i
      else
        status = "unprocessable_content" if status == "unprocessable_entity"
        Rack::Utils::SYMBOL_TO_STATUS_CODE[status.to_sym]

      end
    end

    def status_code_to_text(status_code)
      Rack::Utils::HTTP_STATUS_CODES[status_code] || "Unknown Status Code"
    end
  end
end
