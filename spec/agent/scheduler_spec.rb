require 'spec_helper'

describe Agent::Scheduler do
  When(:scheduler) { Agent.scheduler.run }
  Then { expect(scheduler).to respond_to :every }
end
