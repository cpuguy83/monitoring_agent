module Agent
  class RelationProxy
    attr_reader :collection, :parent_object
    include Enumerable

    def initialize(klass, parent_object)
      @klass = klass
      @parent_object = parent_object
      @collection = []
      @mutex = Mutex.new
    def inspect
      collection
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
      attrs[:relation_proxy] = self
      service = @klass.new(attrs)
      synchronize do
        @collection << service
      end
      service
    end

  end
end
