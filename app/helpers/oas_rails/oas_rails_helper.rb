module OasRails
  module OasRailsHelper
    def rapi_docs_config
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
      }.map { |k, v| %(#{k}=#{ERB::Util.html_escape(v)}) }.join(' ')
    end

    def logo_url
      false
    end
  end
end
