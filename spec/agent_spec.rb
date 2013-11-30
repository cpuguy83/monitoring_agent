require 'spec_helper'

module Maxwell
  describe Agent do
    describe '.start' do
      When { Agent.start! }
      Then { expect(Agent).to be_running }
      And { expect(Agent.runner).to be_an Agent::Runner }

      context 'Agent is started again' do
        Given { Agent.start! }
        Given(:runner) { Agent.runner }
        When { Agent.start! }
        Then { expect(runner).to be Agent.runner }
      end

    end

    describe '.stop' do
      Given { Agent.start! }
      When { Agent.stop }
      Then { expect(Agent).to be_stopped }
    end

    context 'agent is restarted' do
      Given!(:agent1) { Agent.start! }
      Given { Agent.stop }
      When { Agent.start! }
      Then { expect(Agent).to be_running }
    end

    it 'Survives an Actor System reboot' do
      Agent.start!
      runner = Agent.runner

      Celluloid.shutdown
      Celluloid.boot
      Agent.start!

      expect(Agent.runner).to_not be runner
    end
  end
end
