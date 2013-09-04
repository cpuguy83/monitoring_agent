module Agent
  class WorkQueue
    include Celluloid

    attr_reader :queue

    def initialize
      @queue = []
    end

    def add(work)
      @queue << work
      @queue.uniq!

      work
    end

    def count
      @queue.count
    end

    def get
      @queue.shift
    end

    def put_back(work)
      @queue.unshift(work)
    end

  end
end
