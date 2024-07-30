module OasRails
  class OasBase
    def to_spec
      hash = {}
      instance_variables.each do |var|
        key = var.to_s.delete('@')
        camel_case_key = key.camelize(:lower).to_sym
        value = instance_variable_get(var)

        processed_value = if value.respond_to?(:to_spec)
                            value.to_spec
                          else
                            value
                          end

        # hash[camel_case_key] = processed_value unless (processed_value.is_a?(Hash) || processed_value.is_a?(Array)) && processed_value.empty?
        hash[camel_case_key] = processed_value
      end
      hash
    end

    private

    def snake_to_camel(snake_str)
      words = snake_str.to_s.split('_')
      words[1..].map!(&:capitalize)
      (words[0] + words[1..].join).to_sym
    end
  end
end
