module Agent
  class RelationProxy
    attr_reader :collection
    include Enumerable

    def initialize(klass, parent_object)
      @klass = klass
      @parent_object = parent_object
      @collection = []
      @mutex = Mutex.new
    end

    def each(&block)
      collection.each do |c|
        block.call(c)
      end
    end

    def synchronize(&block)
      @mutex.synchronize do
        block.call
      end
    end

    def build(attrs={})
      service = @klass.new(attrs)
      synchronize do
        @collection << service
      end
      set_parent_on_child_object(service)
      service
    end
  private
     def set_parent_on_child_object(child_object)
        child_object.instance_variable_set(
          "@#{@parent_object.class.to_s.downcase.split('::').last}",
          @parent_object)
     end
  end
end
