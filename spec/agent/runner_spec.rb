require 'spec_helper'

describe Agent::Runner do
  describe '.run' do
    When { Agent::Runner.run! }
    Then { expect(Celluloid::Actor[:worker]).to be_an Agent::Worker  }
  end
end
