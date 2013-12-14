require 'maxwell/agent/redis_objects/set'
require 'maxwell/agent/redis_objects/sorted_set'

module Maxwell
  module Agent
    module RedisObjects
      def redis(&block)
        Agent.redis(&block)
      end

      def self.included(base)
        base.send(:include, ::Celluloid)
      end
    end
  end
end
