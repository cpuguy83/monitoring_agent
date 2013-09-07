module Agent
  class Worker

    include Celluloid

    def perform(work)
      work.perform
    ensure
      work.last_run = Time.now
      put_back(work)
    end

  private
    def put_back(work)
      Actor[:work_schedule].put_back(work)
    end

  end
end
