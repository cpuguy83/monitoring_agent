module Agent
  class Worker
    include Celluloid

    def perform(work)
      work.perform

      post_run(work)
    end

    def work_schedule
      Agent.runner[:work_schedule]
    end

  private

    def post_run(work)
      work.perform_at = nil
      work.last_run = Time.now
      work_schedule.put_back(work)

      Agent.middleware.invoke(work)
    end

  end
end
