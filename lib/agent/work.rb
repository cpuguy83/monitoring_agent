module Agent
  class Work
    attr_reader :attributes
    def self.instance_attrs
      [:name, :work_class, :arguments, :perform_at, :frequency,
        :last_run, :output, :other_attributes]
    end

    def to_json
      hash = {}
      self.class.instance_attrs.each do |attr|
        hash[attr] = self.send(attr)
      end

      hash.to_json
    end

    def initialize(attrs={})
      @attributes = {}

      sendable_attrs = attrs.select { |key, value| self.class.instance_attrs.include? key }
      
      sendable_attrs.each do |key, value|
        public_send("#{key}=", value)
      end
      
      yield self if block_given?
      self.last_run ||= Time.new(0)
      self.frequency ||= 30.minutes
    end

    instance_attrs.each do |attr|
      define_method attr do |value=nil|
        @attributes[attr] = value if value
        @attributes[attr]
      end

      define_method "#{attr}=" do |value|
        @attributes[attr] = value
      end
    end

    def ==(other)
      other.class == self.class &&
        other.attributes.except(:id) == self.attributes.except(:id)
    end

    def work_now?
      case
        when perform_at then perform_at_less_than_now?
        when frequency  then stale?
        else                 true
      end
    end

    def perform
      arguments ? perform_with_arguments :  perform_without_arguments
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
