require 'spec_helper'

describe Agent::Scheduler do
  When(:scheduler) { Agent::Scheduler.new }
  Then { expect(scheduler).to respond_to :every }

  describe '.run' do
    When(:result) { scheduler.async.run }
    Then { expect(scheduler).to be_alive }
  end
end
