module Maxwell
  module Agent
    class EventedWorker < Worker
      include Celluloid::IO
    end
  end
end
