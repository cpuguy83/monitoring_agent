require 'spec_helper'

describe Agent do
  describe '.start' do
    Given { Agent.start! }
    When(:result) { Agent.runner }
    Then { expect(result).to be_an Agent::Runner }
    Then { expect(result).to be_alive }
  end

  describe '.stop' do
    Given { Agent.start! }
    When { Agent.stop }
    Then { expect(Agent.runner).to be_nil }
  end

  it 'Survives a reset' do
    Agent.start!
    runner = Agent.runner

    Celluloid.shutdown
    Celluloid.boot
    Agent.start!

    expect(Agent.runner).to_not be runner
  end
end
