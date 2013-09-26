require 'spec_helper'

describe Agent::Runner do
  describe '.run' do
    When { Agent::Runner.run! }
    Then { expect(Agent.runner[:worker]).to be_an Agent::Worker  }
    Then { expect(Agent.runner[:scheduler]).to be_an Agent::Scheduler }
  end
end
