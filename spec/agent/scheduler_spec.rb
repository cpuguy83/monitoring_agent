require 'spec_helper'
module Agent
  describe Scheduler do
    before :each do
      runner = double(:runner)
      Agent.stub(:runner).and_return(runner)
      allow(runner).to receive(:[]).with(:scheduler).and_return(Agent::Scheduler.new)
    end
    Given(:scheduler) { Agent.runner[:scheduler] }
  end
end
