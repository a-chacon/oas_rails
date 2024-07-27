module OasRails
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        template "oas_rails_initializer.rb", "config/initializers/oas_rails.rb"
      end
    end
  end
end
