module Maxwell
  module Agent
    module Coercable
      def self.included(base)
        base.extend ClassMethods
        base.instance_variable_set('@coercions', {})
      end


      def coerce_values!(attrs)
        attrs.each do |key, value|
          attrs[key] = coerce_value(key, value) if self.class.coercions[key]
        end
        attrs
      end

      def coerce_value(key, value)
        coercion_class = self.class.coercions[key]
        case
          when coercion_class.is_a?(Proc) then coercion_class.call(value)
          else coercion_class.new(value)
        end
      end

      module ClassMethods
        def coercions
          @coercions ||= {}
        end

        def coerce(key, as)
          @coercions[key] = as
        end

      end
    end
  end
end

