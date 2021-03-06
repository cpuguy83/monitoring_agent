module Maxwell
  module Agent
    class Worker

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

        Agent.runner[:middleware_runner].inoke(work)
      end
    end
  end
end
