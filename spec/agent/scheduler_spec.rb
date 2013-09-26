require 'spec_helper'
module Agent
  describe Scheduler do
    Given(:scheduler) { Agent.runner[:scheduler] }
  end
end
