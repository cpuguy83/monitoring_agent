require 'spec_helper'
class Foo; end
class Bar; end

module Maxwell
  module Agent
    class WorkTest < Host::Service
      include Work
    end

    describe Work do
      Given(:work) { WorkTest.new name: :foo, work_class: 'Foo' }
      Given(:work2) { WorkTest.new name: :bar, work_class: 'Bar' }

      describe '#load' do
        Given(:work_json) { work.to_json }
        When(:result) { Work.load(work_json) }
        Then { expect(work_json).to eq(result.to_json) }
      end

      describe '.work_now?' do
        context 'work is scheduled normally' do
          Given { work.last_run = 1000.hours.ago }
          Given { work.frequency = 1.minute }
          When(:result) { work.work_now? }
          Then { expect(result).to be true }
        end

        context 'work is scheduled before it should be' do
          Given { work.frequency = 1000.hours }
          Given { work.last_run = 1.minute.ago }
          When(:result) { work.work_now? }
          Then { expect(result).to be false }
        end

        context 'scheduled to run in the past' do
          Given { work.perform_at = 1.minute.ago }
          When(:result) { work.work_now? }
          Then { expect(result).to be true }
        end

        context 'work is scheduled for the future' do
          Given { work.frequency = nil }
          Given { work.perform_at = 100.hours.from_now }
          When(:result) { work.work_now? }
          Then { expect(result).to be false }
        end
      end

      describe 'work ranking' do
        describe 'perform_at takes precedence all else equal' do
          Given(:work1) { WorkTest.new(perform_at: Time.now).generate_rank }
          Given(:work2) { WorkTest.new(last_run: 10.minutes.ago, frequency: 5.minutes).
                          generate_rank }
          Then { expect(work1).to be < work2 }
        end

        describe 'perform_at with earlier time comes first' do
          Given(:work1) { WorkTest.new(perform_at: Time.now).generate_rank }
          Given(:work2) { WorkTest.new(perform_at: 5.minutes.from_now).generate_rank }
          When(:result) { work1 < work2 }
          Then { expect(work1).to be < work2  }
        end

        describe "work which hasn't run comes before that which has" do
          Given(:work1) { WorkTest.new(frequency: 5.minutes).generate_rank }
          Given(:work2) { WorkTest.new(last_run: 10.minutes.ago, frequency: 5.minutes)
                          .generate_rank }
          Then { expect(work1).to be < work2 }
        end

      end

      describe '.verify_required_attributes!' do
        Given(:work) { WorkTest.new }
        When(:result) { work.verify_required_attributes! }
        Then { expect(result).to raise_error Work::MissingRequiredAttributeError }
      end
    end
  end
end
