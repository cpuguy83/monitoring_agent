require 'bundler/setup'
Bundler.require(:default, (ENV['RACK_ENV'] || :development))
require 'ostruct'

require 'agent/runner'
require 'agent/configuration'
require 'agent/relation_proxy'
require 'agent/host'
require 'agent/check_agent'
require 'agent/work'

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
      wait_for_actor_boot
      @runner
    end

    def stop
      runner.terminate
    ensure
      cleanup_dead_runner
    end

    def work(work_class)
      worker.perform(work_class: work_class)
    end

    def worker
      runner.worker
    end

    def work_queue
      runner.work_queue
    end

    def scheduler
      runner.scheduler
    end

  private
    def wait_for_actor_boot
      loop do
        break if runner && runner.work_queue &&
          runner.scheduler &&
          runner.worker
      end
    end

    def dead_runner?
      if runner
        unless runner.alive?
          true
        end
      end
    end

    def cleanup_dead_runner
      if dead_runner?
        @runner = nil
      end
    end

  end
end



