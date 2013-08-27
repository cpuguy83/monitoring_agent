require 'agent/worker'
require 'agent/scheduler'

module Agent
  class Runner < Celluloid::SupervisionGroup
    supervise Agent::Worker, as: :worker, size: 10
    supervise Agent::Scheduler, as: :scheduler
  end
end
