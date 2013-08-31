module Agent
  module CheckAgent
    extend ActiveSupport::Concern

    included do
      private_class_method :call_handler, :get_instance
      attr_accessor :output, :args
    end

    module ClassMethods
      def perform(*args)
        check_agent = get_instance(*args)
        check_agent.output = check_agent.perform(*args)
        call_handler(check_agent)
      end

      def get_instance(*args)
        instance = new
        instance.args = args
        instance
      end

      def call_handler(check_agent)
        check_agent.handle if check_agent.respond_to?(:handle)
      end
    end
  end
end
