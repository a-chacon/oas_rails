module OasRails
  class Contact < OasBase
    attr_accessor :name, :url, :email

    def initialize(**kwargs)
      super()
      @name = kwargs[:name] || ''
      @url = kwargs[:url] || ''
      @email = kwargs[:email] || ''
    end
  end
end
