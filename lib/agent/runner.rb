require 'agent/worker'
require 'agent/scheduler'

module Agent
  class Runner < Celluloid::SupervisionGroup
    supervise Agent::Worker, as: :worker, size: 10
    supervise Agent::Scheduler, as: :scheduler

    def worker
      Celluloid::Actor[:worker]
    end
  end
end
