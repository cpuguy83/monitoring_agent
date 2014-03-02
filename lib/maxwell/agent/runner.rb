require 'maxwell/agent/worker'
require 'maxwell/agent/standard_worker'
require 'maxwell/agent/evented_worker'
require 'maxwell/agent/scheduler'
require 'maxwell/agent/work_schedule'

module Maxwell
  module Agent
    class Runner < Celluloid::SupervisionGroup

      attr_reader :registry

      def self.worker_pool_size
        Agent.configuration.worker_concurrency
      end

      def initialize(opts)
        super

        supervise_as :work_schedule, Agent::WorkSchedule
        pool Agent::StandardWorker, as: :worker, size: self.class.worker_pool_size
        supervise_as :evented_worker, Agent::EventedWorker
        supervise_as :scheduler, Agent::Scheduler,
          work_schedule: self[:work_schedule],
          worker: self[:worker],
          evented_worker: self[:evented_worker]


        self[:scheduler].async.run

      end

      def [](actor_name)
        @registry[actor_name]
      end
    end
  end

end
