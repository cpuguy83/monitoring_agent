module Maxwell
  module Agent
    class Host
      class Service
        extend Forwardable
        attr_reader :attributes
        include Work

        def_delegators :attributes,
          :perform_at, :perform_at=,
          :last_run, :last_run=,
          :frequency, :frequency=,
          :work_class, :work_class=

        class Serializer
          include Coercable

          coerce :perform_at, Time
          coerce :last_run, Time

          def self.serialize(attrs)
            attrs.last_run   = attrs.last_run.to_s if attrs.last_run
            attrs.perform_at = attrs.perform_at.to_s if attrs.perform_at
            JSON.dump attrs
          end

          def self.deserialize(json)
            hash = JSON.parse(json, symbolize_names: true)
            Service.new(new.coerce_values!(hash))
          end
        end

        def initialize(attrs={})
          @attributes = Attributes.new(attrs)
          set_default_attrs!
        end

        def serialize
          Serializer.serialize(attributes.dup)
        end

        def to_json
          serialize
        end

      end
    end
  end
end
