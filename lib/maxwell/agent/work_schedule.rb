module Maxwell
  module Agent
    class WorkSchedule
      include Celluloid

      def initialize
        @schedule = RedisObjects::SortedSet.new('work_schedule')
        @working  = RedisObjects::Set.new('work_schedule:working')
      end

      def add(work)
        @schedule.async.add(work.generate_rank, work)
        work
      end

      def count
        schedule.count
      end

      def get
        find_ready_for_work
      end

      def put_back(work)
        @working.remove(work)
        add(work)
      end

      def working
        @working.all.map {|work| Work.load(work) }
      end

      def schedule
        @schedule.all.map {|work| Work.load(work) }
      end

      def all
        schedule.concat(working)
      end

    private

      def find_ready_for_work
        work = get_work
        move_to_working_queue(work) if work && work.work_now?
        work
      end

      def get_work
        work = @schedule.first
        Work.load(work) if work
      end

      def move_to_working_queue(work)
        @working.add(work)
        @schedule.async.remove(work)
      end

      def is_being_worked_on?(work)
        @working.exists?(work)
      end
    end
  end
end
