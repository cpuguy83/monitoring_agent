require 'json'
require 'open-uri'
module Maxwell
  module Agent
    class Configuration
      attr_accessor :worker_concurrency, :host_configuration, :work_poll,
        :redis_options
      attr_reader :middleware_chain

      def initialize
        @worker_concurrency = 25
        @middleware_chain = default_middleware
        @work_poll = 1
        @host_configuration = 'config/host_configuration.json'
        @redis_options = { host: 'localhost', port: 6379 }
      end

      def middleware
        @middleware_chain ||= default_middleware
        yield @middleware_chain if block_given?
        @middleware_chain
      end

      def default_middleware
        Middleware::Chain.new do |m|
          m.add Middleware::Logging
        end
      end
    end
  end
end
