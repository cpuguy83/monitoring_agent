[![Build Status](https://travis-ci.org/cpuguy83/maxwell_agent.png)](https://travis-ci.org/cpuguy83/maxwell_agent)

# Maxwell agent

The intention of this is as yet another Nagios replacement.
It is an single process, multithreaded monitoring agent
It is based on the Celluloid Actor framework.

This is 1 part of 3 piece monitoring framework.<br>
####Maxwell agent(this)
 - the actual monitoring process

###Maxwell agent reporting WUI -
 - View check results/stats (akin to the main Nagios WUI)

###server
 - Store agents configs
 - View agent results
 - Agents check in to get configuration
 - Agents check in to report check results and other statistics

This is still in early development, use at your own risk

To use:
```ruby
require 'maxwell_agent'
Maxwell::Agent.start!
```
Check out config/schedule.rb for an example on how to schedule work.<br />
Major changes are coming to this configuration, what's here now is for example only.

Everything is currently kept only in-memory.<br>
If the agent is restarted all data will be lost<br>


###Middleware
You can write your own middleware which gets run after each check is performed.<br>
In the middleware you have access to the "work" object.<br>
The work object is where check results and other bits of info are stored.

To write your middleware:
```ruby
module Maxwell
  module Agent
    module Middleware
      class MyAwesomeMiddlewares
        def call(work)
          # Some awesome stuff before passing to the next item in the chain
          yield
          # Some more awesome stuff once the chain bubbles back up
        end
      end
    end
  end
end
```
You register your middleware as such:
```ruby
Maxwell::Agent.configure do |config|
  config.middleware do |chain|
    chain.add Maxwell::Middleware::MyAwesomeMiddlewares
  end
end
```
Your middleware must define a "call" method.<br>
Everything before the yield is called before passing on to the next middleware<br>
Everything after the yield is called after the rest of the middleware stack has run<br>
If you do not yield in your middleware call it will break the chain (and likely the app)


### Probes
Probes are the actual monitoring checks that get performed.<br />
To create a probe include "Maxwell::Agent::Probe" into your class.<br />
You must define a "perform" instnace method which is what gets called by Maxwell Agent.<br />
You can optionally define a "handle" instance method which gets run after perform, and should take a single argument<br />

By default when your probe is scheduled it is sent to a worker pool to complete.
Maxwell also has the ability to take advantage of evented I/O.<br />
If you know your probe uses evented/non-blocking IO compatible with Celluloid add the following to your class:
```ruby
class Foo
  include Maxwell::Agent::Probe

  self.work_type = :evented
end
```
The work type option will have your probe sent to the evented worker instead of the normal worker pool.<br />
Only set this option if your probe is doing mostly non-blocking I/O.<br />
Maxwell will come with several pre-built evented I/O probes that you can use.

## Contributing to agent

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Brian Goff. See LICENSE.txt for
further details.


