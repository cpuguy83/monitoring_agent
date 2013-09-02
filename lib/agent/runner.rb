require 'agent/worker'
require 'agent/scheduler'
require 'agent/work_queue'

module Agent
  class Runner < Celluloid::SupervisionGroup
    pool Agent::Worker, as: :worker, size: 10
    supervise Agent::Scheduler, as: :scheduler
    supervise Agent::WorkQueue, as: :work_queue

    def worker
      Celluloid::Actor[:worker]
    end
  end
end
