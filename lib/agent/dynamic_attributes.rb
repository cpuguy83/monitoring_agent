module Agent
  module DynamicAttributes
    def method_missing(method_name, *args)
      singleton_class.
        class_eval { attr_accessor method_name.to_s.gsub(/=$/, '') }
      send(method_name, *args)
    end
  end
end
