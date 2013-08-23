require 'agent/worker'

module Agent
  class Runner < Celluloid::SupervisionGroup
    supervise Agent::Worker, as: :worker, size: 10
  end
end
