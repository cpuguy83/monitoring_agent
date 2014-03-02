module Maxwell
  module Agent
    class Scheduler
      include Celluloid

      attr_reader :work_schedule, :evented_worker, :worder

      def initialize(opts={})
        @work_schedule ||= opts.fetch(:work_schedule)
        @evented_worker ||= opts.fetch(:evented_worker)
        @worker ||= opts.fetch(:worker)
      end

      def run
        set_links
        loop do
          sleep Agent.configuration.work_poll
          schedule_work
        end
      end

      def schedule_work
        work = work_schedule.get
        if work.evented?
          evented_worker.async.perform(work)
        else
          worker.async.perform(work)
        end
      end
    private
      def set_links
        link(@evented_worker)
        link(@worker)
        link(@work_schedule)
      end

    end
  end
end
