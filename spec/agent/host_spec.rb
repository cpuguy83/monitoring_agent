require 'spec_helper'

describe Agent::Host do
  describe '.services' do
    Given(:host) { Agent::Host.new }
    When { host.services.build }
    Then { expect(host.services).to respond_to :count}
    Then { expect(host.services).to respond_to :each }
  end
end
