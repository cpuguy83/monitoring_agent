module Maxwell
  module Agent
    class Scheduler
      include Celluloid

      def initialize
        async.run
      end

      def work_schedule
        runner[:work_schedule]
      end

      def run
        loop do
          sleep Maxwell.configuration.work_poll
          schedule_work
        end
      end

      def schedule_work
        work = work_schedule.get
        worker.async.perform(work) if work
      end

      def worker
        runner[:worker]
      end

      def runner
        links.detect {|link| Celluloid::SupervisionGroup === link }
      end

    end
  end
end
