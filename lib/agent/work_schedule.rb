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
      remove_from_working_queue(work)
      async.add(work)
    end

    def working
      work_items = redis do |redis|
        redis.smembers 'work_schedule:working'
      end
      work_items.map {|work| Work.new(JSON.parse(work)) }
    end

    def schedule
      work_items = redis do |redis|
        redis.zrange 'work_schedule', 0, -1
      end
      work_items.map {|work| Work.new(JSON.parse(work)) }
    end

  private
    def redis(&block)
      Agent.redis(&block)
    end

    def find_ready_for_work
      work = get_work
      move_to_working_queue if work && work.work_now?
      work
    end

    def get_work
      work = redis do |redis|
        redis.zrange('work_schedule', 0, 0)[0]
      end

      Work.new(JSON.parse(work)) if work
    end

    def move_to_working_queue(work)
      add_to_working_queue(work)
      remove_from_main_queue(work)
    end

    def remove_from_main_queue(work)
      redis do |redis|
        key = redis.zrank 'work_schedule', work.to_json
        redis.zrem 'work_schedule', key
      end
    end

    def add_to_working_queue(work)
      redis do |redis|
        redis.sadd 'work_schedule:working', work.to_json
      end
    end

    def remove_from_working_queue(work)
      redis do |redis|
        redis.srem work.to_json
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
