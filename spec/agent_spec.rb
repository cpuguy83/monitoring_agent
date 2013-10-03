require 'spec_helper'

describe Agent do
  describe '.start' do
    Given { Agent.start! }
    When(:result) { Agent.runner }
    Then { expect(result).to be_an Agent::Runner }
    And { expect(result).to be_alive }
  end

  describe '.stop' do
    Given { Agent.start! }
    When { Agent.stop }
    Then { expect(Agent.runner).to be_nil }
  end
end
