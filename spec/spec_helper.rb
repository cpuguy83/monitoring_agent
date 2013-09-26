require 'rspec/given'
require 'agent'

RSpec.configure do |config|
  config.before(:each) do
    Celluloid.shutdown
    Celluloid.boot
    Agent.start!
  end
end
