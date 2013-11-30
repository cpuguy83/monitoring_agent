require 'spec_helper'
module Maxwell
  module Agent
    describe Scheduler do
      before :each do
        runner = double(:runner)
        Maxwell.stub(:runner).and_return(runner)
        allow(runner).to receive(:[]).with(:scheduler).and_return(Maxwell::Scheduler.new)
      end
      Given(:scheduler) { Maxwell.runner[:scheduler] }
    end
  end
end
