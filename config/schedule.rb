class MyWorker
  include Agent::CheckAgent
  def perform
    Logger.new('/tmp/test2.log').info('Stuff')
  end
end

work 'alias' do
  frequency 5.seconds
  work_class MyWorker
end
