require 'spec_helper'
module Maxwell
  module Agent
    describe WorkSchedule do
      before :each do
        runner = double(:runner)
        Agent.stub(:runner).and_return(runner)
        allow(runner).to receive(:[]).with(:work_schedule).
          and_return(WorkSchedule.new)
      end

      Given(:queue) { Agent.runner[:work_schedule] }
      Given(:work) { Host::Service.new(name: 'foo', work_class: 'bar') }
      describe '.add' do
        context 'Work is added' do
          When(:result) { queue.add(work) }
          Then { expect(queue.count).to eq 1 }
        end
        context 'The same Work is added 2x' do
          Given { queue.add(work) }
          When { queue.add(work) }
          Then { expect(queue.count).to eq 1 }
        end
      end

      describe '.working' do
        Given { queue.add(work) }
        When { queue.get }
        Then { expect(queue.working.count).to eq 1 }
        And  { expect(queue.count).to  eq 0 }
      end

      describe '.put_back' do
        Given { queue.add(work) }
        Given { queue.get }
        When  { queue.put_back(work) }
        Then  { expect(queue.count).to eq 1 }
        And   { expect(queue.working.count).to eq 0 }
      end

      describe '.all' do
        Given { queue.add(work) }
        Given { queue.add(Host::Service.new(name: 'foo', work_class: 'bar',
                                       perform_at: 5.minutes.ago)) }
        When  { queue.get }
        Then  { expect(queue.all.count).to eq 2 }
        And   { expect(queue.working.count).to eq 1 }
        And   { expect(queue.schedule.count).to eq 1 }
      end

    end
  end
end
