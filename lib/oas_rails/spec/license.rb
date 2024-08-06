module OasRails
  module Spec
    class License
      include Specable

      attr_accessor :name, :url

      def initialize(**kwargs)
        @name = kwargs[:name] || 'GPL 3.0'
        @url = kwargs[:url] || 'https://www.gnu.org/licenses/gpl-3.0.html#license-text'
      end

      def oas_fields
        [:name, :url]
      end
    end
  end
end
