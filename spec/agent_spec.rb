require 'spec_helper'

module Maxwell do
  describe Agent do
    describe '.start' do
      When { Maxwell.start! }
      Then { expect(Maxwell).to be_running }
      And { expect(Maxwell.runner).to be_an Maxwell::Runner }

      context 'Maxwell is started again' do
        Given { Maxwell.start! }
        Given(:runner) { Maxwell.runner }
        When { Maxwell.start! }
        Then { expect(runner).to be Maxwell.runner }
      end

    end

    describe '.stop' do
      Given { Maxwell.start! }
      When { Maxwell.stop }
      Then { expect(Maxwell).to be_stopped }
    end

    context 'agent is restarted' do
      Given!(:agent1) { Maxwell.start! }
      Given { Maxwell.stop }
      When { Maxwell.start! }
      Then { expect(Maxwell).to be_running }
    end

    it 'Survives an Actor System reboot' do
      Maxwell.start!
      runner = Maxwell.runner

      Celluloid.shutdown
      Celluloid.boot
      Maxwell.start!

      expect(Maxwell.runner).to_not be runner
    end
  end
end
