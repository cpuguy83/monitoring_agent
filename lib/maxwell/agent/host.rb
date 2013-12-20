module Maxwell
  module Agent
    class Host
      attr_reader :attributes
      require 'maxwell/agent/host/service'

      class Serializer
        include Coercable

        coerce :services, ->(services) {
          services.map { |service|
            Service::Serializer.deserialize(service)
          }}
        def self.serialize(attrs)
          attrs.services = attrs.services.map(&:serialize)
          JSON.dump attrs
        end

        def self.deserialize(json)
          hash = JSON.parse(json, symbolize_names: true)
          Host.new(new.coerce_values!(hash))
        end
      end


      def initialize(attrs={})
        @attributes = Attributes.new(attrs)
        @attributes.services ||= []
      end

      def serialize
        Serializer.serialize(attributes.dup)
      end


      def add_service(service)
        @attributes[:services] << service
      end

      def services
        @attributes[:services]
      end

    end

  end
end

