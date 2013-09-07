require 'spec_helper'

describe Agent::Work do
  Given(:work) { Agent::Work.new work_class: 'Foo' }
  Given(:work2) { Agent::Work.new work_class: 'Bar' }
  describe '==' do
    When(:result) { [work, work, work2].uniq! }
    Then { expect(result.count).to be 2 }
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
end
