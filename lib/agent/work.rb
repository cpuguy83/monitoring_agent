module Agent
  class Work
    attr_reader :attributes
    def self.instance_attrs
      [:work_class, :arguments, :perform_at]
    end
    def initialize(attrs={})
      @attributes = {}

      attrs.each do |key, value|
        if self.class.instance_attrs.include? key
          public_send("#{key}=", value)
        end
      end
    end

    instance_attrs.each do |attr|
      define_method attr do
        @attributes[attr]
      end

      define_method "#{attr}=" do |value|
        @attributes[attr] = value
      end
    end

    def ==(other)
      other.class == self.class &&
        other.attributes == self.attributes
    end

  end
end
