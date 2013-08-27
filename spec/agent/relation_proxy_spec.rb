require 'spec_helper'
Foo = Struct.new(:bar)

describe Agent::RelationProxy do
  describe '.build'
  Given(:proxy) { Agent::RelationProxy.new(Foo) }
  When(:result) { proxy.build }
  Then { expect(result).to be_a Foo }
  Then { expect(proxy.collection.count).to be 1 }
end
