module OasRails
  module Spec
    class Contact
      include Specable
      attr_accessor :name, :url, :email

      def initialize(**kwargs)
        @name = kwargs[:name] || ''
        @url = kwargs[:url] || ''
        @email = kwargs[:email] || ''
      end

      def oas_fields
        [:name, :url, :email]
      end
    end
  end
end
