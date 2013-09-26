module Agent
  class Host
    class Service
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

    attr_reader :services, :hosts, :attributes

    def initialize(attrs={})
      @services = RelationProxy.new(Service, self)
      @hosts = RelationProxy.new(self.class, self)
      attrs.delete(:services)
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
end
