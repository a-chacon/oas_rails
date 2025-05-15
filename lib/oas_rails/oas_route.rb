module OasRails
  class OasRoute
    attr_accessor :controller_class, :controller_action, :controller, :controller_path, :method, :verb, :path,
                  :rails_route, :docstring, :source_string
    attr_writer :tags

    def initialize(attributes = {})
      attributes.each { |key, value| send("#{key}=", value) }
    end

    def path_params
      @path.scan(/:(\w+)/).flatten.reject! { |e| e == 'format' }
    end

    def tags(name = nil)
      return @tags if name.nil?

      @tags.select { |tag| tag.tag_name.to_s == name.to_s }
    end
  end
end
