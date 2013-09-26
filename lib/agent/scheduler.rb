module Agent
  class Scheduler

    class Configuration
      def initialize
        load_config
      end

      def work(name=nil, &block)
        work = Agent::Work.new
        work.name = name if name
        work.instance_eval(&block)

        work.save

        work
      end
      alias_method :check, :work


    private
      def load_config
        file = File.expand_path("../../../config/schedule.rb", __FILE__)
        eval(File.open(file).read) if File.exists? file
      end
    end

    include Celluloid

    def initialize
      async.load_config
      async.run
    end

    def work_schedule
      Agent.runner[:work_schedule]
    end

    def run
      loop { schedule_work }
    end

    def schedule_work
      work = work_schedule.get
      worker.async.perform(work) if work
    end

    def worker
      Agent.runner[:worker]
    end

  private
    def load_config
      Configuration.new
    end

  end
end
