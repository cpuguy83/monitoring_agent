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

    describe '.get' do
      Given { queue.add(work) }
      When(:result) { queue.get }
      Then  { expect(result).to eq(work) }

      describe 'Work is pulled is sorted when pulled' do
        describe 'Use only frequency/last_run' do
          Given(:work) { Work.new(last_run: 10.minutes.ago,
                                  frequency: 5.minutes)}
          Given(:work2) { Work.new(last_run: 9.minutes.ago,
                                   frequency: 5.minutes)}
          Given { queue.add(work) }
          Given { queue.add(work2) }
          When(:result) { queue.get }
          Then { expect(result).to eq(work) }
        end
        context 'Both work items are compared using perform_at' do
          Given(:work) { Work.new(perform_at: 2.minutes.from_now) }
          Given(:work2) { Work.new(perform_at: 1.minute.ago) }
          Given { queue.add(work) }
          Given { queue.add(work2) }
          When(:result) { queue.get }
          Then { expect(result).to eq(work2) }
        end

        context 'First uses perform_at, 2nd uses frequency/last_run' do
          context '1 work item has not been run before' do
            Given(:work) { Work.new(perform_at: 2.minutes.from_now) }
            Given(:work2) { Work.new(frequency: 1000.minutes) }
            Given { queue.add(work) }
            Given { queue.add(work2) }
            When(:result) { queue.get }
            Then { expect(result).to eq(work2) }
          end

          context 'Work items have run before' do
            context 'perform_at is sooner than last_run/frequency' do
              Given(:work) { Work.new(perform_at: Time.now,
                                             last_run: 1.minute.ago) }
              Given(:work2) { Work.new(last_run: 10.minutes.ago,
                                              frequency: 1000.minutes) }
              Given { queue.add(work) }
              Given { queue.add(work2) }
              When(:result) { queue.get }
              Then { expect(result).to eq(work) }
            end
            context 'last_run/frequency is sooner' do
              Given(:work) { Work.new(perform_at: Time.now,
                                             last_run: 1.minute.ago ) }
              Given(:work2) { Work.new(last_run: 10.minutes.ago,
                                              frequency: 1.minute) }
              Given { queue.add(work) }
              Given { queue.add(work2) }
              When(:result) { queue.get }
              Then { expect(result).to eq(work2) }
            end
          end
        end
      end
    end
  end
end
