module OasRails
  class Tag
    attr_accessor :name, :description

    def initialize(name:, description:)
      @name = name.titleize
      @description = description
    end

    def to_spec
      {
        name: @name,
        description: @description
      }
    end
  end
end
