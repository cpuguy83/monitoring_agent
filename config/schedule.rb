require 'open-uri'
class MyWorker
  include Agent::CheckAgent
  def perform(n)
    ::Logger.new('/tmp/test2.log').info("Testing #{n}")
    Kernel.sleep 10
  end
end
counter = 0
40.times do
  work "work#{counter}" do
    frequency 5.seconds
    work_class MyWorker
    arguments counter +=1
  end
end

