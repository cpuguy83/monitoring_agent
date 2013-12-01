require 'rspec/given'
require 'maxwell/agent'

RSpec.configure do |config|
  config.before(:each) do
    Celluloid.shutdown
    Celluloid.boot
    Maxwell::Agent.redis {|redis| redis.flushdb }
  end
end
