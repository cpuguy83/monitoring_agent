require 'bundler/setup'
Bundler.require(:default, (ENV['RACK_ENV'] || :development))

require 'agent/runner'

module Agent
  class << self
    def runner
      @runner
    end

    def start
      @runner ||= Runner.run
    end

    def start!
      @runner ||= Runner.run!
    end


    def stop
      @runner.terminate
    ensure
      @runner = nil unless @runner.alive?
    end

  end
end
