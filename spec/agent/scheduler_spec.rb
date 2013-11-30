require 'spec_helper'
module Maxwell
  module Agent
    describe Scheduler do
      before :each do
        runner = double(:runner)
        Agent.stub(:runner).and_return(runner)
        allow(runner).to receive(:[]).with(:scheduler).and_return(Maxwell::Scheduler.new)
      end
      Given(:scheduler) { Agent.runner[:scheduler] }
    end
  end
end
