require 'spec_helper'

describe Agent do
  describe '.start' do
    When(:result) { Agent.start! }
    Then { expect(result).to be_an Agent::Runner }
  end

  describe '.stop' do
    Given { Agent.start! }
    When { Agent.stop }
    Then { expect(Agent.runner).to be nil}
  end

  describe '.runner' do
    Given { Agent.start! }
    Then { expect(Agent.runner).to be_a Agent::Runner }
    Then { expect(Agent.runner).to be_alive }
  end
end
