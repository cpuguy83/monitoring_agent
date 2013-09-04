require 'agent/worker'
require 'agent/scheduler'
require 'agent/work_queue'

module Agent
  class Runner < Celluloid::SupervisionGroup
    pool Agent::Worker, as: :worker, size: 10
    supervise Agent::WorkQueue, as: :work_queue
    supervise Agent::Scheduler, as: :scheduler

    [:work_queue, :scheduler, :worker].each do |actor|
      define_method actor do
        Celluloid::Actor[actor]
      end
    end
  end


end
