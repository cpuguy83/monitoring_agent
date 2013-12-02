module Maxwell
  module Agent
    class Worker
      include Celluloid::IO

      def perform(work)
        work.perform

        post_run(work)
      ensure
        work_schedule.put_back(work)
      end

      def work_schedule
        Agent.runner[:work_schedule]
      end

    private

      def post_run(work)
        work.perform_at = nil
        work.last_run = Time.now

        Agent.middleware.invoke(work)
      end
    end
  end
end
