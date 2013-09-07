require 'rspec/given'
require 'agent'

RSpec.configure do |config|
  config.before(:each) do
    Celluloid.shutdown
    Celluloid.boot
    Agent.stub(:runner).and_return(Agent::Runner.run!)
  end
end
