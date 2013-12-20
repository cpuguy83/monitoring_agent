module Maxwell
  module Agent
    class Host
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
        @services ||= []
        @hosts ||= []
      def serialize
        Serializer.serialize(attributes.dup)
      end

      def add_service(service)
        self.services << service
      end

      def add_host(host)
        self.hosts << host
      end
    end
  end
end
