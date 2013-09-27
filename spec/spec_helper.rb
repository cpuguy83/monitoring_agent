require 'rspec/given'
require 'agent'

RSpec.configure do |config|
  config.before(:each) do
    Celluloid.shutdown
    Celluloid.boot
  end
end
