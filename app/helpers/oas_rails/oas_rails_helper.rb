module OasRails
  module OasRailsHelper
    def rapidoc_configuration_attributes
      {
        "spec-url" => "#{OasRails::Engine.routes.find_script_name({})}.json",
        "show-header" => "true",
        "font-size" => "largest",
        "show-method-in-nav-bar" => "as-colored-text",
        "nav-item-spacing" => "relaxed",
        "allow-spec-file-download" => "true",
        "schema-style" => "table",
        "sort-tags" => "true",
        "persist-auth" => "true"
      }.merge(OasRails.config.rapidoc_configuration).map { |k, v| %(#{k}=#{ERB::Util.html_escape(v)}) }.join(' ')
    end

    def rapidoc_logo_url
      OasRails.config.rapidoc_logo_url
    end
  end
end
