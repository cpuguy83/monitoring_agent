require 'spec_helper'
module Agent
  describe WorkSchedule do
    before :each do
      runner = double(:runner)
      Agent.stub(:runner).and_return(runner)
      WorkSchedule::Configuration.stub(:load).
        and_return([])
      allow(runner).to receive(:[]).with(:work_schedule).
        and_return(WorkSchedule.new)
    end

    Given(:queue) { Agent.runner[:work_schedule] }
    Given(:work) { Work.new }
    describe '.add' do
      context 'Work is added' do
        When { queue.add(work) }
        Then { expect(queue.count).to be 1 }
      end
      context 'The same Work is added 2x' do
        Given { queue.add(work) }
        When { queue.add(work) }
        Then { expect(queue.count).to be 1 }
      end
    end

  end
end
