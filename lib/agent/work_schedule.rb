module Agent
  class WorkSchedule
    include Celluloid

    module Configuration
      def self.load(schedule)
        config_json = JSON.parse(open(Agent.configuration.host_configuration).
                                      read, symbolize_names: true)
        hosts = config_json.collect {|host| Agent::Host.new(host) }
        hosts.each do |host|
          host.services.each do |service|
            work = Work.new(
              name:        service.name,
              work_class:  Object.const_get(service.probe_class),
              frequency:   service.frequency,
              peform_at:   service.perform_at,
              arguments:   service.arguments,
              other_attributes: { service: service })
            schedule.add(work)
          end
        end
      end
    end

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
      move_to_working_queue(work)
      async.add(work)
    end

  private
    def redis(&block)
      Agent.redis(&block)
    end

    def find_ready_for_work
      redis do |redis|
        work_json = redis.zrange('work_schedule', 0, 0)[0]
        work = JSON.parse(work_json) if work_json
        if work && Work.new(work).work_now?
          key = redis.zrank 'work_schedule', work
          redis.sadd 'work_schedule:working', work
          redis.zrem 'work_schedule', key
          Work.new work
        end
      end
    end

    def move_to_working_queue(work)
      add_to_working_queue(work)
      remove_from_main_queue(work)
    end

    def remove_from_main_queue(work)
      redis do |redis|
        redis.srem 'work_schedule', work.to_json
      end
    end

    def add_to_working_queue(work)
      redis do |redis|
        redis.sadd 'work_schedule:working'
      end
    end

    def add_work(work)
      redis do |redis|
        redis.zadd 'work_schedule', work.generate_rank, work.to_json
      end
    end

    def is_being_worked_on?(work)
      redis do |redis|
        redis.sismember work.to_json
      end
    end

  end
end
