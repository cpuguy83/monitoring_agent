require 'agent/worker'
require 'agent/scheduler'
require 'agent/work_schedule'

module Agent
  class Runner < Celluloid::SupervisionGroup

    attr_reader :registry

    supervise Agent::WorkSchedule, as: :work_schedule
    pool Agent::Worker, as: :worker, size: 10
    supervise Agent::Scheduler, as: :scheduler

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
