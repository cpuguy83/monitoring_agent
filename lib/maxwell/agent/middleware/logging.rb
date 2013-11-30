module Maxwell
  module Agent
    module Middleware
      class Logging
        def call(work, &chain)
          chain.call
          ::Logger.new('/tmp/test2.log').info("Ran #{work.name}")
        end
      end
    end
  end
end
