require 'rspec/given'
require 'fakeredis/rspec'
require 'agent'

RSpec.configure do |config|
  config.before(:each) do
    Celluloid.shutdown
    Celluloid.boot
  end
end
