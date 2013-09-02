require 'spec_helper'

describe Agent::Work do
  Given(:work) { Agent::Work.new work_class: 'Foo' }
  Given(:work2) { Agent::Work.new work_class: 'Bar' }
  describe '==' do
    When(:result) { [work, work, work2].uniq! }
    Then { expect(result.count).to be 2 }
  end
end
