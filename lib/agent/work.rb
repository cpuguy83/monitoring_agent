module Agent
  module Work
    def self.included(base)
      base.send :attr_reader, :attributes
      base.send :attr_accessor, :name, :work_class, :arguments, :perform_at,
        :frequency, :last_run, :output
    end

    def to_json
      instance_variables.inject({}) do |result, attr|
        result.merge(attr => instance_variable_get(attr))
      end.to_json
    end

    def initialize(attrs={})
      attrs.each {|attr, value| send("#{attr}=", value) if respond_to? attr}
      yield self if block_given?
      @last_run ||= Time.new(0)
      @frequency ||= 30.minutes
    end

    def work_now?
      case
        when perform_at then perform_at_less_than_now?
        when frequency  then stale?
        else                 true
      end
    end

    def perform
      arguments ? perform_with_arguments : perform_without_arguments
    end

    def expected_next_run
      case
        when perform_at               then perform_at + last_run.to_i
        when (last_run && frequency)  then last_run + frequency
        else                          Time.new
      end
    end

    def generate_rank
      expected_next_run.to_i
    end

  private

    def perform_with_arguments
      work_class.perform(arguments)
    end

    def perform_without_arguments
      work_class.perform
    end

    def time_since_last_run
      Time.now - last_run
    end

    def perform_at_less_than_now?
      return perform_at.find {|at| at <= Time.now } if perform_at.respond_to? :each
      perform_at <= Time.now
    end

    def stale?
      time_since_last_run >= frequency
    end
  end
end
