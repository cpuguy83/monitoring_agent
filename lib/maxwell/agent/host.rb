module Maxwell
  module Agent
    class Host

      class Service
        include Work
        def initialize(attrs={})
          @hosts ||= []
        end
      end

      def initialize(attrs={})
        @services ||= []
        @hosts ||= []
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
