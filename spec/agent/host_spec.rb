require 'spec_helper'

describe Agent::Host do
  describe '.services' do
    Given(:host) { Agent::Host.new }
    Then { expect(host.services).to respond_to :count}
    Then { expect(host.services).to respond_to :each }
  end
end
