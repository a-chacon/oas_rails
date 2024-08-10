module OasRails
  module Spec
    require 'digest'

    module Hashable
      def hash_key
        Hashable.generate_hash(hash_representation)
      end

      def hash_representation
        public_instance_variables.sort.to_h { |var| [var, instance_variable_get(var)] }
      end

      def self.generate_hash(obj)
        Digest::MD5.hexdigest(hash_representation_recursive(obj).to_s)
      end

      def public_instance_variables
        instance_variables.select do |var|
          method_name = var.to_s.delete('@')
          respond_to?(method_name) || respond_to?("#{method_name}=")
        end
      end

      def self.hash_representation_recursive(obj)
        case obj
        when Hash
          obj.transform_values { |v| hash_representation_recursive(v) }
        when Array
          obj.map { |v| hash_representation_recursive(v) }
        when Hashable
          obj.hash_representation
        else
          obj
        end
      end
    end
  end
end
