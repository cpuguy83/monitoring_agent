require 'spec_helper'
module Maxwell
  module Agent
    describe Probe do

      context 'Probe is included' do
        Given(:probe) { Class.new { include Probe } }
        When(:result) { probe.work_type }
        Then { expect(result).to eq(:non_evented) }
      end
    end
  end
end
