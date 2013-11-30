module Maxwell
  module Agent
    module Work
      class MissingRequiredAttributeError < StandardError; end

      REQUIRED_ATTRIBUTES = [:name, :work_class]
      #WORK_ATTRIBUTES     = [:last_run, :frequency, :perform_at].
      #  concat(REQUIRED_ATTRIBUTES)

      def self.included(base)
        base.send(:include, DynamicAttributes)
      end


      def self.load(json)
        work = from_json(json)
        work.delete('klass').constantize.new.load(work)
      end

      def self.from_json(json)
        JSON.parse(json)
      end

      def load(attrs={})
        attrs.each do |key, value|
          send("#{key}=", value )
        end
        self
      end

      def to_json
        verify_required_attributes!
        instance_variables.inject({}) do |result, attr|
          result.merge(attr.to_s.gsub('@','') => instance_variable_get(attr))
        end.merge({klass: self.class}).to_json
      end

      def verify_required_attributes!
        REQUIRED_ATTRIBUTES.each do |required_attr|
          raise MissingRequiredAttributeError,
            "Must set #{required_attr}" unless send(required_attr)
        end
      end

      def last_run
        super || self.last_run = Time.new(0)
      end

      def frequency
        super || self.frequency = 30.minutes
      end

      def work_now?
        case
          when perform_at then perform_at_less_than_now?
          when frequency  then stale?
          else                 true
        end
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

      def perform
        work_class.perform(*arguments)
      end

    private
      def time_since_last_run
        Time.now.to_i - last_run.to_i
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
end
