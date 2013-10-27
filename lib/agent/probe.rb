module Agent
  module Probe

    def self.included(base)
      base.extend(ClassMethods)
      base.instance_eval do
        private_class_method :call_handler, :get_instance
        attr_accessor :output, :args
      end
    end

    module ClassMethods
      def perform(*args)
        probe = get_instance(*args)
        probe.output = check_agent.perform(*args)
        call_handler(probe)
      end

      def get_instance(*args)
        instance = new
        instance.args = args
        instance
      end

      def call_handler(probe)
        check_agent.handle if check_agent.respond_to?(:handle)
      end
    end
  end
end
