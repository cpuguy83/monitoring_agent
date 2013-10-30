require 'bundler/setup'
Bundler.require(:default, (ENV['RACK_ENV'] || :development))

require 'agent/configuration'
require 'agent/middleware/chain'
require 'agent/middleware/logging'
require 'agent/relation_proxy'
require 'agent/host'
require 'agent/probe'
require 'agent/work'


module Agent
  class << self
    def runner
      @runner
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration if block_given?
      configuration
    end

    def start
      if dead_runner?
        load_host_configuration
        @runner = Runner.run
      end
    end

    def start!
      if dead_runner?
        load_host_configuration
        @runner = Runner.run!
      end
    end

    def stop
      runner.terminate
    end

    def middleware
      yield configuration.middleware_chain if block_given?
      configuration.middleware_chain
    end

    def running?
      runner.alive?
    end

    def stopped?
      !running?
    end

  private

    def dead_runner?
      if runner && runner.alive?
        false
      else
        true
      end
    end

    def cleanup_dead_runner
      if dead_runner?
        @runner = nil
      end
    end

    # TODO: Actually load this configuration and parse it into work
    def load_host_configuration
      config_json = JSON.parse(open(configuration.host_configuration).
                                      read, symbolize_names: true)
      hosts = config_json.collect {|host| Agent::Host.new(host) }
    end

  end
end

require 'agent/runner'
