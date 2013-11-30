require 'spec_helper'
module Maxwell
  module Agent
    describe Host do
      describe '.services' do
        Given(:host) {Host.new }
        Then { expect(host.services).to respond_to :count}
        Then { expect(host.services).to respond_to :each }
      end
    end
  end
end
