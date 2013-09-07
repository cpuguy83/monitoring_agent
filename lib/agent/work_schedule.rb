module Agent
  class WorkSchedule
    include Celluloid
    include Enumerable

    attr_reader :schedule, :working

    def initialize
      @schedule = []
      @working  = []
    end

    def add(work)
      add_work(work) unless is_being_worked_on?(work)
      work
    end

    def each(&block)
      @schedule.each { |s| block.call(s) }
    end

    def get
      work = find_ready_for_work
      if work
        move_to_working_queue(work)
        work
      end
    end

    def clear
      @schedule = []
      @working = []
    end

    def put_back(work)
      @working.delete(work)
      add(work)
    end

  private
    def find_ready_for_work
      schedule.sort.find { |w| w.work_now? }
    end

    def move_to_working_queue(work)
      @schedule.delete(work)
      @working << work
    end

    def add_work(work)
      @schedule << work
      @schedule.uniq!
    end

    def is_being_worked_on?(work)
      @working.find { |w| w == work }
    end

  end
end
