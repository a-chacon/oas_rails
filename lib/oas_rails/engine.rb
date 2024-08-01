module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails
    config.to_prepare do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'YARD'
      end
    end
  end
end
