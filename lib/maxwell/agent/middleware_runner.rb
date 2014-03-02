module Maxwell
  module Agent
    class MiddlewareRunner
      include Celluloid

      def invoke(work)
        Agent.middleware.invoke(work)
      end
    end
  end
end
