module Agent
  class Worker
    include Celluloid

    attr_reader :work_schedule

    def perform(work)
      @work_schedule ||= Actor[:work_schedule]

      work.perform

      post_run(work)
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
