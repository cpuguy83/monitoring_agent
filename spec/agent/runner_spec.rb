require 'spec_helper'

describe Agent::Runner do
  describe '.run' do
    When(:runner) { Agent::Runner.run! }
    Then { expect(runner[:worker]).to be_an Agent::Worker  }
    Then { expect(runner[:scheduler]).to be_an Agent::Scheduler }
  end
end
