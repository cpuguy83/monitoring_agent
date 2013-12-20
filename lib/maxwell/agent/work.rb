module Maxwell
  module Agent
    module Work
      class MissingRequiredAttributeError < StandardError; end

      def self.load(json)
        Agent::Host::Service::Serializer.deserialize(json)
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
          else                          Time.new(0)
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

      def set_default_attrs!
        last_run
        frequency
      end
    end
  end
end
