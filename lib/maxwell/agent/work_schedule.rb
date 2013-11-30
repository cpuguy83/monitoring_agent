module Maxwell
  module Agent
    class WorkSchedule
      include Celluloid

      def add(work)
        async.add_work(work)
        work
      end

      def count
        redis do |redis|
          redis.zcard 'work_schedule'
        end
      end

      def get
        find_ready_for_work
      end

      def put_back(work)
        remove_from_working_queue(work)
        async.add(work)
      end

      def working
        work_items = redis do |redis|
          redis.smembers 'work_schedule:working'
        end
        work_items.map {|work| Work.load(work) }
      end

      def schedule
        work_items = redis do |redis|
          redis.zrange 'work_schedule', 0, -1
        end
        work_items.map {|work| Work.load(work) }
      end

      def all
        schedule.concat(working)
      end

    private
      def redis(&block)
        Agent.redis(&block)
      end

      def find_ready_for_work
        work = get_work
        move_to_working_queue(work) if work && work.work_now?
        work
      end

      def get_work
        work = redis do |redis|
          redis.zrange('work_schedule', 0, 0)[0]
        end

        Work.load(work) if work
      end

      def move_to_working_queue(work)
        add_to_working_queue(work)
        remove_from_main_queue(work)
      end

      def remove_from_main_queue(work)
        redis do |redis|
          redis.zrem 'work_schedule', work.to_json
        end
      end

      def add_to_working_queue(work)
        redis do |redis|
          redis.sadd 'work_schedule:working', work.to_json
        end
      end

      def remove_from_working_queue(work)
        redis do |redis|
          redis.srem 'work_schedule:working', work.to_json
        end
      end

      def add_work(work)
        redis do |redis|
          redis.zadd 'work_schedule', work.generate_rank, work.to_json
        end
      end

      def is_being_worked_on?(work)
        redis do |redis|
          redis.sismember 'work_schedule:working', work.to_json
        end
      end
    end
  end
end
