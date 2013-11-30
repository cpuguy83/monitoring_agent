require 'maxwell/agent/worker'
require 'maxwell/agent/scheduler'
require 'maxwell/agent/work_schedule'

module Maxwell
  module Agent
    class Runner < Celluloid::SupervisionGroup

      attr_reader :registry

      def self.worker_pool_size
        Maxwell.configuration.worker_concurrency
      end

      supervise Maxwell::WorkSchedule, as: :work_schedule
      pool Maxwell::Worker, as: :worker, size: worker_pool_size
      supervise Maxwell::Scheduler, as: :scheduler

      def [](actor_name)
        @registry[actor_name]
      end

      def initialize(opts)
        super
        wait_for_actor_boot
      end

      def wait_for_actor_boot
        loop do
          break if self[:work_schedule] &&
            self[:worker] &&
            self[:scheduler]
        end
      end
    end
  end

end
