module Agent
  class WorkSchedule
    include Celluloid
    include Enumerable

    attr_reader :schedule, :working

    module Configuration
      def self.load(schedule)
        config_json = JSON.parse(open(Agent.configuration.host_configuration).
                                      read, symbolize_names: true)
        hosts = config_json.collect {|host| Agent::Host.new(host) }
        hosts.each do |host|
          host.services.each do |service|
            work = Work.new(
              name:        service.name,
              work_class:  service.probe_class,
              frequency:   service.frequency,
              peform_at:   service.perform_at,
              arguments:   service.arguments,
              other_attributes: { service: service })
            schedule.add(work)
          end
        end
      end
    end

    def initialize
      @working  = []
      @schedule = []
      Configuration.load(self)
    end

    def add(work)
      async.add_work(work) unless is_being_worked_on?(work)
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
      async.add(work)
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
