module Agent
  class Host
    class Service < OpenStruct; end
    attr_reader :services, :hosts, :attributes

    def initialize(attrs={})
      @services = RelationProxy.new(Service)
      @hosts = RelationProxy.new(self.class)
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
