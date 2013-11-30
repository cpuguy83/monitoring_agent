module Maxwell
  module Agent
    module Probe
      def self.included(base)
        base.extend(ClassMethods)
        base.instance_eval do
          private_class_method :call_handler, :instance
          attr_accessor :output, :args
        end
      end

      module ClassMethods
        def perform(*args)
          probe = instance(*args)
          probe.output = probe.perform(*args)
          call_handler(probe)
        end

        def instance(*args)
          instance = new
          instance.args = args
          instance
        end

        def call_handler(probe)
          probe.handle if probe.respond_to?(:handle)
        end
      end
    end
  end
end
