module Agent
  class RelationProxy
    attr_reader :collection
    include Enumerable

    def initialize(klass)
      @klass = klass
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
      service
    end
  end
end
