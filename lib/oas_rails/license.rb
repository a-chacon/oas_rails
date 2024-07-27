module OasRails
  class License < OasBase
    attr_accessor :name, :url

    def initialize(**kwargs)
      super()
      @name = kwargs[:name] || 'GPL 3.0'
      @url = kwargs[:url] || 'https://www.gnu.org/licenses/gpl-3.0.html#license-text'
    end
  end
end
