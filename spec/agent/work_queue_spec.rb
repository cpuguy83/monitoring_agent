require 'spec_helper'

describe Agent::WorkQueue do
  Given(:queue) { Agent::WorkQueue.new }
  Given(:work) { double(:work) }
  Given { work.stub(:attributes).and_return({foo: :bar }) }
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
    Then { expect(queue.count).to be 0 }
    Then  { expect(result).to be work }
  end

  describe '.put_back' do
    Given { queue.add(work) }
    Given(:work2) { double(:work2) }
    When { queue.put_back(work2) }
    Then { expect(queue.queue.first).to eq(work2) }
    And { expect(queue.count).to be 2 }
  end
end
