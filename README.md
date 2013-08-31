# agent

The intention of this is as yet another Nagios replacement.
It is an single process, multithreaded monitoring agent
It is base donthe Celluloid Actor framework.

This is 1 part of 3 piece monitoring framework.<br>
####agent(this)
 - the actual monitoring process
 
###agent reporting WUI - 
 - View check results/stats (akin to the main Nagios WUI)

###server
 - Store agents configs
 - View agent results
 - Agents check in to get configuration
 - Agents check in to report check results and other statistics

This is still in early development but is actually functional.

Everything is currently kept only in-memory.<br>
This means we aren't storing last check times or anything.<br>
The work scheduler is completely naive to keep early development simple.<br>

####To use:
  - gem install from github
  - Put jobs in config/schedule.rb <br>This is using the clockwork gem, so check out the API there.

```ruby
every 5.minutes, 'Some Job' { SomeJobClass }
```
Where SomeJobClass is the class that has the logic for perform the check

```ruby
class SomeJobClass
  include Agent::CheckAgent

  def perform
    # ...
    # Main check logic here
  end

  def handle
    # ...
    # Optional
    # Put how to handle the check result here
    # Has access to:
    #   .args - the args passed into your perform method
    #   .output - The output from your perform method
  end
end
```


```ruby
require 'agent'
Agent.start! # Does not block main thread
# or
Agent.start # Blocks the main thread
```

Currently hardcoded to start 10 worker agents
No work queue is implemented yet, so once you have 1 busy workers, it will block


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


