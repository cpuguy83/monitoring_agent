module Agent
  class Host
    class Service
      attr_reader :attributes
      def initialize(attrs={})
        relation = attrs[:relation_proxy]
        @host = relation.parent_object
        attrs.delete(:relation_proxy)
        @attributes = attrs
      end

      def method_missing(method_name, arg=nil)
        if method_name.to_s =~ /=$/
          method_name = method_name.to_s.gsub(/=$/, '').to_sym
          @attributes.send(:[]=, method_name, arg)
        else
          attributes.fetch(method_name.to_sym) { nil }
        end
      end
    end

    attr_reader :services, :collection, :attributes

    def initialize(attrs={})
      @services = RelationProxy.new(Service, self)
      @hosts = RelationProxy.new(self.class, self)
      attrs[:services].each {|service| add_service(service) } if attrs[:services]
      attrs.delete(:services)
      attrs[:hosts].each { |host| add_host(host) } if attrs[:hosts]
      attrs.delete(:hosts)
      @attributes = attrs
    end

    def method_missing(method_name, arg=nil)
      if method_name.to_s =~ /=$/
        method_name = method_name.to_s.gsub(/=$/, '').to_sym
        @attributes.send(:[]=, method_name, arg)
      else
        attributes.fetch(method_name.to_sym) { nil }
      end
    end
  private
    def add_service(service)
      @services.build(service)
    end

    def add_host(host)
      @hosts.build(host)
    end
  end
end
